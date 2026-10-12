param(
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter(Mandatory)]
    [string]$EmployeeID,

    [Parameter(Mandatory)]
    [ValidateSet("KIT", "HAM")]
    [string]$Clinic
)

$ErrorActionPreference = "Stop"

Import-Module ActiveDirectory

$domain = Get-ADDomain
$username = ($FirstName.Substring(0,1) + $LastName).ToLower()

$ou = "OU=Clinical Operations,OU=Employees,OU=Asterbridge,$($domain.DistinguishedName)"

$groups = @(
    "GRP-CORP-AllStaff",
    "GRP-CLINIC-$Clinic-FrontDesk"
)

$created = $false

try {
    # Validate the organizational unit
    Get-ADOrganizationalUnit -Identity $ou | Out-Null

    # Validate all required security groups
    foreach ($group in $groups) {
        Get-ADGroup -Identity $group | Out-Null
    }

    # Prevent duplicate usernames
    if (Get-ADUser -Filter "SamAccountName -eq '$username'") {
        throw "Account $username already exists."
    }

    # Prevent duplicate employee IDs
    if (Get-ADUser -Filter "EmployeeID -eq '$EmployeeID'") {
        throw "Employee ID $EmployeeID already exists."
    }

    # Request temporary password securely
    $password = Read-Host "Enter temporary password for $username" -AsSecureString

    # Create account disabled
    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $username `
        -UserPrincipalName "$username@$($domain.DNSRoot)" `
        -EmployeeID $EmployeeID `
        -Department "Clinical Operations" `
        -Title "Front Desk Receptionist" `
        -Description "Synthetic IAM lifecycle test account" `
        -Path $ou `
        -Enabled $false

    $created = $true

    # Set password
    Set-ADAccountPassword `
        -Identity $username `
        -Reset `
        -NewPassword $password

    # Require password change at first login
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true

    # Assign approved groups
    foreach ($group in $groups) {
        Add-ADGroupMember -Identity $group -Members $username
    }

    # Enable account only after successful provisioning
    Enable-ADAccount -Identity $username

    Write-Host "SUCCESS: $username provisioned." -ForegroundColor Green
}
catch {
    if ($created) {
        Disable-ADAccount -Identity $username -ErrorAction SilentlyContinue
    }

    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Review any partially created account before retrying." -ForegroundColor Yellow
}