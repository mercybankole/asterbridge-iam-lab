$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

$username = "obennett"
$oldGroup = "GRP-CLINIC-HAM-FrontDesk"
$newGroup = "GRP-CLINIC-KIT-FrontDesk"
$corporateGroup = "GRP-CORP-AllStaff"

try {
    # Validate the employee
    $user = Get-ADUser -Identity $username `
        -Properties EmployeeID, Enabled, Office

    if ($user.EmployeeID -ne "LAB-JML-001") {
        throw "Employee ID mismatch. Transfer stopped."
    }

    if (-not $user.Enabled) {
        throw "Employee account is disabled."
    }

    # Validate security groups
    foreach ($group in @($oldGroup, $newGroup, $corporateGroup)) {
        Get-ADGroup -Identity $group | Out-Null
    }

    # Check existing memberships
    $memberships = @(
        Get-ADPrincipalGroupMembership $username |
        Select-Object -ExpandProperty SamAccountName
    )

    if ($oldGroup -notin $memberships) {
        throw "Employee does not have the expected Hamilton access."
    }

    if ($newGroup -in $memberships) {
        throw "Employee already has Kitchener access."
    }

    if ($corporateGroup -notin $memberships) {
        throw "Corporate membership missing. Review required."
    }

    # Remove previous clinic access
    Remove-ADGroupMember `
        -Identity $oldGroup `
        -Members $username `
        -Confirm:$false

    # Grant newly approved clinic access
    Add-ADGroupMember `
        -Identity $newGroup `
        -Members $username

    # Update workplace information
    Set-ADUser -Identity $username `
        -Office "Kitchener Clinic"

    # Verify the new state
    $finalGroups = @(
        Get-ADPrincipalGroupMembership $username |
        Select-Object -ExpandProperty SamAccountName
    )

    $updatedUser = Get-ADUser $username -Properties Office

    if (
        $oldGroup -in $finalGroups -or
        $newGroup -notin $finalGroups -or
        $corporateGroup -notin $finalGroups -or
        $updatedUser.Office -ne "Kitchener Clinic"
    ) {
        throw "Post-transfer verification failed."
    }

    Write-Host "SUCCESS: Olivia transferred to Kitchener." -ForegroundColor Green
}
catch {
    Write-Host "TRANSFER FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Check account permissions before continuing." -ForegroundColor Yellow
}