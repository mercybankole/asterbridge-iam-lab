<#
.SYNOPSIS
  Read-only reference for a named service-account inventory in the Asterbridge AD lab.
.NOTES
  Reconstructed from interactive PowerShell used during Project 05.
  This standalone version has not been independently executed or validated.
  It checks only the three listed identities; it is not a complete discovery solution.
  No accounts or permissions are changed.
#>
[CmdletBinding()]
param([string]$OutputDirectory = 'C:\AsterbridgeLab\IAM\ServiceAccountReview')

$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction Stop

$names = @('OktaService','svc-clinic-backup','svc-legacy-reports')
$inventory = foreach ($name in $names) {
    $user = Get-ADUser -Identity $name -Properties Description,Enabled,PasswordNeverExpires,LastLogonDate,Created -ErrorAction Stop
    $groups = @(Get-ADPrincipalGroupMembership -Identity $user.DistinguishedName -ErrorAction Stop |
        Select-Object -ExpandProperty Name)
    $status = if ($user.Enabled -and
        $user.Description -match 'Retired' -and
        $user.Description -match 'Owner: Unassigned') {
        'Potential Orphan'
    } else {
        'No Orphan Flag'
    }
    [PSCustomObject]@{
        Account = $user.SamAccountName
        Enabled = $user.Enabled
        Description = $user.Description
        Created = $user.Created
        LastLogon = $user.LastLogonDate
        PasswordNeverExpires = $user.PasswordNeverExpires
        Groups = ($groups -join '; ')
        ReviewStatus = $status
    }
}
New-Item -ItemType Directory -Path $OutputDirectory -Force -ErrorAction Stop | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$inventory | Export-Csv -LiteralPath (Join-Path $OutputDirectory "Service-Account-Inventory-$timestamp.csv") -NoTypeInformation -Encoding UTF8
$inventory | Select-Object Account,Enabled,ReviewStatus | Format-Table -AutoSize
