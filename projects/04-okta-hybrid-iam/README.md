# Project 04: Hybrid Active Directory & Okta IAM

## Overview

I connected my Asterbridge Active Directory lab in Oracle VirtualBox to Okta using a Windows Server 2022 VM in Azure. I wanted to test how AD users, security groups and account changes carry over to Okta.

I joined the Azure server to `mydomain.com` over a Tailscale connection, configured split DNS and installed Okta AD Agent 3.23.0. All users and company details in this lab are fictional.

## What I configured

- Joined an Azure member server to the existing AD domain hosted in VirtualBox.
- Installed the Okta AD Agent using a dedicated `OktaService` account.
- Limited the directory import to the Asterbridge employee OUs and security groups.
- Imported eight employee accounts and eight AD security groups into Okta.
- Assigned a test Bookmark App, Asterbridge Front Desk Portal, to `GRP-CLINIC-HAM-FrontDesk`.
- Used manual full imports to check group changes and account deactivation and reactivation.

## Test results

| Test | Observed result |
| --- | --- |
| AD import | 8 users and 8 groups imported |
| Group membership | `GRP-CORP-AllStaff` contained all 8 employees |
| Delegated authentication | Hannah Reid authenticated using her AD credentials |
| Group-based assignment | Samuel Ortiz received the Front Desk Portal assignment through his AD group |
| Access removal | Removing Samuel from the AD group removed the Okta application assignment after import |
| Access restoration | Re-adding Samuel to the group restored the application assignment |
| Deprovisioning | Disabling Samuel in AD deactivated his Okta account after import |
| Reactivation | Re-enabling Samuel in AD restored his Okta account and group-based assignment after reactivation settings were corrected |

The import performed after account disabling reported one user removed from the imported set. Samuel's existing Okta profile remained present with the status `Deactivated`.

## Evidence

The supporting screenshots are numbered E01–E14 in the [evidence index](evidence/README.md). The individual tests and their evidence references are recorded in [test cases and results](docs/test-cases.md).

## What I learned

I saw how AD group membership can control application assignments in Okta. When I removed Samuel from the Hamilton Front Desk group, his application assignment disappeared after a full import. It returned after I restored the group membership.

Reactivation needed an extra configuration change. Samuel's first reassignment failed because Okta still considered his account inactive. After I enabled `Reactivate deactivated Okta users` and repeated the import, his account and assignment returned.

## Scope and limitations

This was a lab with eight fictional employees, one Azure-hosted AD Agent and an Okta trial. I ran manual imports rather than measuring automatic sync intervals. The Bookmark App tested Okta assignments; it did not enforce access to a live clinical system. I did not test end-user SSO, MFA, active-session termination or production application provisioning.

The servers communicated over Tailscale, but I did not configure LDAPS or a highly available agent setup. The installer also reported a service-account permissions warning that was not separately validated or remediated. The results demonstrate the actions tested here, not a production-ready identity deployment or a compliance audit.
