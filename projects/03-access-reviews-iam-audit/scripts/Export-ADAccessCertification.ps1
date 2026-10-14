<#
.SYNOPSIS
  Read-only Asterbridge AD role-group certification.
.DESCRIPTION
  Reconstructed reference script based on the commands performed in the lab.
  Not rerun/tested in this exact file form. No directory objects are modified.
  Expects a SIMULATED role-baseline CSV: Username, ExpectedAccess, ExpectedEnabled.
.EXAMPLE
  .\Export-ADAccessCertification.ps1 -BaselineCsv .\Simulated-Role-Baseline.csv -OutputDirectory C:\AsterbridgeLab\IAM\AccessReview
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$BaselineCsv,
    [Parameter(Mandatory=$true)][string]$OutputDirectory,
    [string]$OrganizationOU = 'Asterbridge'
)

$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction Stop

$baseline = @(Import-Csv -LiteralPath $BaselineCsv -ErrorAction Stop)
if ($baseline.Count -eq 0) { throw 'Empty approval baseline.' }
$roleMap = @{}
foreach ($entry in $baseline) {
    $id = [string]$entry.Username
    if ([string]::IsNullOrWhiteSpace($id)) { throw 'Baseline contains a blank username.' }
    if ($roleMap.ContainsKey($id)) { throw "Duplicate baseline username: $id" }
    $roleMap[$id] = $entry
}

$domainDN = (Get-ADDomain -ErrorAction Stop).DistinguishedName
$searchBase = "OU=$OrganizationOU,$domainDN"
Get-ADOrganizationalUnit -Identity $searchBase -ErrorAction Stop | Out-Null

$users = @(Get-ADUser -SearchBase $searchBase -SearchScope Subtree -Filter * -Properties Enabled,EmployeeID,Department,Office -ErrorAction Stop)
if ($users.Count -eq 0) { throw "No users found under $searchBase" }

$rows = foreach ($user in $users) {
    $actual = @(Get-ADPrincipalGroupMembership -Identity $user.DistinguishedName -ErrorAction Stop |
        Where-Object { $_.Name -like 'GRP-*' } |
        ForEach-Object { $_.Name } | Sort-Object -Unique)
    $username = [string]$user.SamAccountName

    if ($roleMap.ContainsKey($username)) {
        $entry = $roleMap[$username]
        $expected = @([string]$entry.ExpectedAccess -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Sort-Object -Unique)
        $excess = @($actual | Where-Object { $_ -notin $expected })
        $missing = @($expected | Where-Object { $_ -notin $actual })
        $expectedEnabled = [string]$entry.ExpectedEnabled
        $stateMismatch = ($expectedEnabled -notin @('True','False')) -or ($user.Enabled.ToString() -ne $expectedEnabled)
        $status = if ($excess.Count -gt 0 -or $missing.Count -gt 0 -or $stateMismatch) {'Exception'} else {'Match'}
    } else {
        $expected=@(); $excess=@(); $missing=@(); $expectedEnabled=''; $status='Needs baseline'
    }

    [PSCustomObject]@{
        Employee = $user.Name
        Username = $username
        Enabled = $user.Enabled
        ExpectedEnabled = $expectedEnabled
        ExpectedAccess = ($expected -join '; ')
        ActualAccess = ($actual -join '; ')
        ExcessAccess = ($excess -join '; ')
        MissingAccess = ($missing -join '; ')
        ReviewStatus = $status
        ReviewerDecision = 'Pending'
    }
}

$unseen = @($baseline | Where-Object { $_.Username -notin @($users | ForEach-Object SamAccountName) })
if ($unseen.Count -gt 0) {
    Write-Warning "Baseline users not in OU scope: $($unseen.Username -join ', ')"
}

New-Item -ItemType Directory -Path $OutputDirectory -Force -ErrorAction Stop | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$output = Join-Path $OutputDirectory "AD-Certification-$timestamp.csv"
$rows | Sort-Object Username | Export-Csv -LiteralPath $output -NoTypeInformation -Encoding UTF8 -ErrorAction Stop
$rows | Group-Object ReviewStatus | Select-Object Name,Count | Format-Table -AutoSize
Write-Host "Snapshot saved: $output" -ForegroundColor Green
