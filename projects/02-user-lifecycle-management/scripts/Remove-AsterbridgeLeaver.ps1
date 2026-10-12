$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

$username = "obennett"
$employeeID = "LAB-JML-001"

$domainDN = (Get-ADDomain).DistinguishedName

$disabledOU = "OU=Disabled Users,OU=Asterbridge,$domainDN"

$groups = @(
    "GRP-CORP-AllStaff",
    "GRP-CLINIC-KIT-FrontDesk",
    "GRP-CLINIC-HAM-FrontDesk"
)

try {
    # Validate employee identity
    $user = Get-ADUser $username `
        -Properties EmployeeID,Enabled,DistinguishedName

    if ($user.EmployeeID -ne $employeeID) {
        throw "Employee ID mismatch. Offboarding stopped."
    }

    if (-not $user.Enabled) {
        throw "Account is already disabled. Review required."
    }

    # Validate destination OU
    Get-ADOrganizationalUnit $disabledOU |
        Out-Null

    # Check for unexpected Asterbridge permissions
    $memberships = @(
        Get-ADPrincipalGroupMembership $username
    )

    $unexpected = @(
        $memberships | Where-Object {
            $_.Name -like "GRP-*" -and
            $_.Name -notin $groups
        }
    )

    if ($unexpected.Count -gt 0) {
        throw "Unexpected group membership. Manual review required."
    }

    # Disable account first
    Disable-ADAccount -Identity $username

    Write-Host "Account disabled." -ForegroundColor Yellow

    # Remove assigned access groups
    foreach ($group in $groups) {

        if ($group -in $memberships.Name) {

            Remove-ADGroupMember `
                -Identity $group `
                -Members $username `
                -Confirm:$false

            Write-Host "Removed: $group"
        }
    }

    # Record offboarding status
    Set-ADUser -Identity $username `
        -Description "LAB-JML-001 | Offboarded test employee"

    # Move account to Disabled Users OU
    $user = Get-ADUser $username

    Move-ADObject `
        -Identity $user.DistinguishedName `
        -TargetPath $disabledOU

    # Verify account status and location
    $final = Get-ADUser $username -Properties Enabled

    $remaining = @(
        Get-ADPrincipalGroupMembership $username |
        Where-Object { $_.Name -like "GRP-*" }
    )

    if ($final.Enabled -or $remaining.Count -gt 0) {
        throw "Post-offboarding verification failed."
    }

    if ($final.DistinguishedName -notlike "*$disabledOU") {
        throw "Account was not moved to Disabled Users."
    }

    Write-Host "SUCCESS: Olivia offboarded." -ForegroundColor Green

}
catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Inspect account state before retrying." -ForegroundColor Yellow
}