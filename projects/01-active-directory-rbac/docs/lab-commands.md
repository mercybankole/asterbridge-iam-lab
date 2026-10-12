# Commands and test procedure

These are the core commands used during Project 01. They are recorded here for reproducibility; they were run interactively in the lab, not as a single previously committed automation script.

Use only inside an isolated test environment. ACL commands change folder permissions.

## Verify Active Directory

Run on the domain controller:

```powershell
(Get-ADDomain).DNSRoot
Get-ADDomainController -Filter * | Select-Object HostName, IPv4Address
Get-ADUser -SearchBase "OU=Employees,OU=Asterbridge,DC=mydomain,DC=com" -Filter * -Properties EmployeeID, Department, Enabled |
    Select-Object Name, EmployeeID, Department, Enabled | Sort-Object EmployeeID
```

## Verify the interactive user

Run on the Windows 10 workstation as the test employee, without elevation:

```powershell
whoami
whoami /groups
```

## Inspect NTFS permissions

```powershell
icacls 'C:\AsterbridgeLab\KIT-FrontDesk'
icacls 'C:\AsterbridgeLab\HAM-FrontDesk'
```

For the lab folders, the clinic groups received Modify access while SYSTEM and local Administrators retained Full Control. The folder ACLs were configured by an administrator before testing.

## Hannah Reid: Kitchener front desk

Run as `MYDOMAIN\hreid`, without elevation:

```powershell
'Test by Hannah Reid' | Set-Content 'C:\AsterbridgeLab\KIT-FrontDesk\Hannah-Test.txt'
Get-Content 'C:\AsterbridgeLab\KIT-FrontDesk\Hannah-Test.txt'
'Unauthorized access test' | Set-Content 'C:\AsterbridgeLab\HAM-FrontDesk\Hannah-Test.txt' -ErrorAction Stop
```

The first two operations succeeded. The Hamilton write attempt returned a permission-denied error, as expected.

## Samuel Ortiz: Hamilton front desk

Run as `MYDOMAIN\sortiz`, without elevation:

```powershell
'Test by Samuel Ortiz' | Set-Content 'C:\AsterbridgeLab\HAM-FrontDesk\Samuel-Test.txt' -ErrorAction Stop
Get-Content 'C:\AsterbridgeLab\HAM-FrontDesk\Samuel-Test.txt'
'Unauthorized access test' | Set-Content 'C:\AsterbridgeLab\KIT-FrontDesk\Samuel-Test.txt' -ErrorAction Stop
Get-ChildItem 'C:\AsterbridgeLab\KIT-FrontDesk' -ErrorAction Stop
```

The Hamilton operations succeeded. The Kitchener write and directory-listing attempts were denied, as expected.

## Evidence handling

Original screenshots were captured during the test. The included evidence images are cropped excerpts prepared for readability. They contain no real patient data or passwords. The [formal test report](../report/asterbridge-rbac-test-report.pdf) identifies what was verified and what remains outside scope.
