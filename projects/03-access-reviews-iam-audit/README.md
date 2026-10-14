# Project 03: Active Directory Access Reviews & IAM Audit

## Overview

I performed a simulated access certification for Asterbridge Care Technologies, a fictional healthcare technology company. Using Active Directory and PowerShell, I inventoried nine employee identities, compared role-group memberships with a predefined access matrix and tested whether an intentionally excessive group assignment would be detected and removed.

The environment is an isolated VirtualBox lab using Windows Server 2022, Active Directory and a domain-joined Windows 10 Pro workstation.

## What I did

- Inventoried **nine in-scope accounts**: eight enabled, one disabled.
- Collected an additional read-only privileged group inventory for separate review.
- Compared employee `GRP-*` memberships with a simulated role-access matrix.
- Introduced a controlled cross-clinic access exception for a Kitchener receptionist.
- Confirmed the exception was detected and demonstrated that it allowed access to a Hamilton test folder.
- Removed the unauthorized membership, refreshed the workstation session and confirmed access was restricted again.
- Preserved baseline, exception and post-remediation CSV reports.

## Technical test results

| Point in the review | Matching accounts | Exceptions |
| --- | ---: | ---: |
| Initial baseline | 9 / 9 | 0 |
| After controlled group assignment | 8 / 9 | 1 |
| After remediation | 9 / 9 | 0 |

The detected exception was Hannah Reid's additional `GRP-CLINIC-HAM-FrontDesk` membership. All original `ReviewerDecision` values remain **Pending**. The automated comparison was completed; formal access-owner certification was **not** performed.

## Build and detection evidence

<table>
<tr><td width="50%" valign="top"><strong>Identity population</strong><br><a href="evidence/E01-identity-inventory.png"><img src="evidence/E01-identity-inventory.png" width="390" alt="Nine in-scope Active Directory users"></a></td><td width="50%" valign="top"><strong>Clean role baseline</strong><br><a href="evidence/E02-clean-certification.png"><img src="evidence/E02-clean-certification.png" width="390" alt="Nine technical access matches"></a></td></tr>
<tr><td width="50%" valign="top"><strong>Controlled Hamilton group assignment</strong><br><a href="evidence/E03-controlled-group-assignment.png"><img src="evidence/E03-controlled-group-assignment.png" width="390" alt="Deliberate Hamilton group assignment"></a></td><td width="50%" valign="top"><strong>Access review exception detected</strong><br><a href="evidence/E04-exception-detected.png"><img src="evidence/E04-exception-detected.png" width="390" alt="Hannah flagged with excess access"></a></td></tr>
</table>

## Effective access and remediation evidence

<table>
<tr><td width="50%" valign="top"><strong>Updated Windows group token</strong><br><a href="evidence/E05-fresh-token-both-clinics.png"><img src="evidence/E05-fresh-token-both-clinics.png" width="390" alt="Hannah token includes two clinic role groups"></a></td><td width="50%" valign="top"><strong>Hamilton file access succeeded</strong><br><a href="evidence/E06-cross-clinic-access-confirmed.png"><img src="evidence/E06-cross-clinic-access-confirmed.png" width="390" alt="Read and write tests in Hamilton folder"></a></td></tr>
<tr><td width="50%" valign="top"><strong>Unauthorized membership removed</strong><br><a href="evidence/E07-hamilton-membership-removed.png"><img src="evidence/E07-hamilton-membership-removed.png" width="390" alt="Active Directory membership after remediation"></a></td><td width="50%" valign="top"><strong>Hamilton access denied after fresh sign-in</strong><br><a href="evidence/E08-hamilton-denied-post-remediation.png"><img src="evidence/E08-hamilton-denied-post-remediation.png" width="390" alt="Hamilton denied and Kitchener allowed"></a></td></tr>
</table>

**Final certification:** [Nine accounts again match the defined role matrix](evidence/E09-clean-post-remediation.png).

## Files and documentation

- [IAM access-review test report (PDF)](report/Asterbridge_Project03_IAM_Access_Review_Report_v1.0.pdf)
- [Review notes, evidence definitions and limitations](docs/README-review-notes.md)
- [Read-only PowerShell reference script](scripts/Export-ADAccessCertification.ps1)
- [Source CSV: account inventory](data/AD-Access-Inventory.csv)
- [Clean access certification](data/Access-Certification-Baseline.csv)
- [Exception detected](data/Access-Certification-Exception.csv)
- [Certification after remediation](data/Access-Certification-PostRemediation.csv)
- [Simulated role-access baseline](data/Simulated-Role-Baseline.csv)

The PowerShell file is a **reconstructed reference script** based on the interactive lab commands. It is not presented as separately tested automation.

## What I learned

A successful directory update is not always equivalent to an immediate change in a signed-in user's effective access. In this lab, fresh Windows sign-ins were important for testing updated group memberships. Comparing permissions, demonstrating their effect and retesting after remediation produced clearer evidence than group-membership screenshots alone.

## Scope and limits

Asterbridge and all employee identities are fictional. The test focused on Asterbridge OU users, groups beginning `GRP-*` and two local NTFS clinic test folders. It did not establish permissions for clinical applications, cloud accounts or every domain group. The privileged-access inventory was kept in an internal workbook rather than published with administrative login identifiers. Framework references in the report are illustrative; they do not establish SOC 2 or ISO certification.