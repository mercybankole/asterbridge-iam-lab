# Project 01: Active Directory & Role-Based Access Control

## Overview

I built an Active Directory lab for Asterbridge Care Technologies, a fictional healthcare technology company with clinics in Kitchener and Hamilton, Ontario. The goal was to provision sample employee identities and test whether Windows enforced clinic-specific folder permissions.

The configuration and tests were performed in Oracle VirtualBox using Windows Server 2022, a domain-joined Windows 10 Pro workstation, Active Directory, PowerShell and NTFS permissions.

## What I configured

- Verified an existing Active Directory domain (`mydomain.com`) and domain-joined workstation.
- Created an Asterbridge OU with six core OUs and eight departmental OUs.
- Created eight security groups and eight enabled sample employee accounts.
- Assigned employees to baseline and role-specific groups.
- Configured NTFS Modify permissions for separate Kitchener and Hamilton front-desk folders.
- Tested domain sign-in and allowed and denied file operations using two receptionist accounts.

## Environment build

Screenshots from the Active Directory lab, showing the organizational structure, security groups and provisioned users.

<table>
<tr>
<td width="50%" valign="top"><strong>Asterbridge organizational units</strong><br><a href="evidence/E09-asterbridge-ou-structure.png"><img src="evidence/E09-asterbridge-ou-structure.png" alt="Asterbridge core OUs in Active Directory" width="400"></a></td>
<td width="50%" valign="top"><strong>Eight departments</strong><br><a href="evidence/E10-eight-department-ous.png"><img src="evidence/E10-eight-department-ous.png" alt="Eight organizational units under Employees" width="400"></a></td>
</tr>
<tr>
<td width="50%" valign="top"><strong>Role-based security groups</strong><br><a href="evidence/E11-ad-security-groups.png"><img src="evidence/E11-ad-security-groups.png" alt="Asterbridge AD security groups" width="400"></a></td>
<td width="50%" valign="top"><strong>Eight enabled employee accounts</strong><br><a href="evidence/E01-enabled-users.png"><img src="evidence/E01-enabled-users.png" alt="PowerShell verification of eight sample employee accounts" width="400"></a></td>
</tr>
</table>

## Access design

| Role | Assigned group | Authorized lab folder |
| --- | --- | --- |
| Kitchener receptionist | `GRP-CLINIC-KIT-FrontDesk` | `C:\AsterbridgeLab\KIT-FrontDesk` |
| Hamilton receptionist | `GRP-CLINIC-HAM-FrontDesk` | `C:\AsterbridgeLab\HAM-FrontDesk` |

Both users also belong to `GRP-CORP-AllStaff`. Folder permissions were applied through security groups rather than individual-user ACL entries.

## Test results

| Test | Expected | Observed |
| --- | --- | --- |
| Hannah writes to Kitchener | Allowed | Passed |
| Hannah reads Kitchener file | Allowed | Passed |
| Hannah writes to Hamilton | Denied | Passed |
| Samuel writes to Hamilton | Allowed | Passed |
| Samuel reads Hamilton file | Allowed | Passed |
| Samuel writes to Kitchener | Denied | Passed |

**Result: 6 of 6 core functional tests met their expected outcomes.** Additional checks confirmed Samuel's clinic group membership and denial of Kitchener directory listing.

## Test evidence

These screenshots show the configured permissions and the actual allowed or denied operations. Select an image to enlarge it.

<table>
<tr>
<td width="50%" valign="top"><strong>Domain sign-in and group membership</strong><br><a href="evidence/E02-hannah-groups.png"><img src="evidence/E02-hannah-groups.png" alt="Hannah domain identity and security groups" width="400"></a></td>
<td width="50%" valign="top"><strong>NTFS permission configuration</strong><br><a href="evidence/E03-ntfs-permissions.png"><img src="evidence/E03-ntfs-permissions.png" alt="Kitchener and Hamilton NTFS ACL configurations" width="400"></a></td>
</tr>
<tr>
<td width="50%" valign="top"><strong>Hannah: authorized and denied operations</strong><br><a href="evidence/E04-hannah-tests.png"><img src="evidence/E04-hannah-tests.png" alt="Hannah Kitchener success and Hamilton access denied" width="400"></a></td>
<td width="50%" valign="top"><strong>Hannah: Hamilton folder restricted</strong><br><a href="evidence/E05-hannah-hamilton-denied.png"><img src="evidence/E05-hannah-hamilton-denied.png" alt="Windows permission warning for Hamilton folder" width="400"></a></td>
</tr>
<tr>
<td width="50%" valign="top"><strong>Samuel: authorized and denied operations</strong><br><a href="evidence/E06-samuel-tests.png"><img src="evidence/E06-samuel-tests.png" alt="Samuel Hamilton success and Kitchener access denied" width="400"></a></td>
<td width="50%" valign="top"><strong>Samuel: group membership and list denial</strong><br><a href="evidence/E07-samuel-groups-denial.png"><img src="evidence/E07-samuel-groups-denial.png" alt="Samuel group membership and denied Kitchener listing" width="400"></a></td>
</tr>
<tr>
<td width="50%" valign="top"><strong>Kitchener test file</strong><br><a href="evidence/E08-kitchener-file.png"><img src="evidence/E08-kitchener-file.png" alt="Hannah's test file visible inside Kitchener folder" width="400"></a></td>
<td width="50%"></td>
</tr>
</table>

## Report and procedures

- [RBAC test report (PDF)](report/asterbridge-rbac-test-report.pdf)
- [PowerShell commands and test procedures](docs/lab-commands.md)

## What I learned

The lab showed how AD group membership and NTFS ACLs work together to enforce permissions. I also resolved an account provisioning issue caused by the domain's password requirements. That exposed a weakness in the original provisioning script: it printed a success message even when account creation returned an error. Proper error handling is a focus of my next project.

## Scope and limitations

This was a lab using fictional employees and synthetic text files. The tests were limited to local folders on one workstation and two standard user accounts. They do not demonstrate authorization in Asterbridge's fictional clinical application, a production file server, or the organization's wider workforce. The framework references in the report are learning mappings, not evidence of certification or a completed compliance audit.
