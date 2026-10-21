# Project 06: IT Service Management & IAM Support Simulation

## Overview

I used Jira Service Management and my existing Asterbridge Active Directory–Okta lab to work through four fictional IT support requests. The goal was to practice handling requests from intake through investigation, access decisions, technical changes and documentation.

Asterbridge Care Technologies is a fictional healthcare technology company. The Jira tickets, employee requests and approvals are simulated. The Active Directory, Okta and Windows configurations and the test results described below came from hands-on lab work.

## Environment

- Jira Service Management: Asterbridge IT Service Desk (project key `AIT`)
- Windows Server 2022 with Active Directory Domain Services in Oracle VirtualBox
- Azure-hosted Windows Server running the Okta AD Agent, connected to the lab through Tailscale
- Okta trial organization with AD-sourced identities and groups
- Okta Verify for Windows 11 and Windows Hello

The IAM environment was built in [Project 04: Hybrid Active Directory & Okta IAM](../04-okta-hybrid-iam/). This project focuses on the support workflow built around that environment.

## Support cases

| Ticket | Request | Work completed | Outcome |
| --- | --- | --- | --- |
| AIT-1 | Front Desk Portal access issue | Checked account status, AD/Okta group membership and app assignment; deliberately removed and restored an AD group in the lab | Verified group removal and restoration changed the Okta Bookmark App assignment |
| AIT-2 | Front Desk employee onboarding | Created Jordan Ellis in AD, applied corporate and Front Desk groups, imported into Okta and reviewed assignments | AD-sourced account Active in Okta; expected groups and application assignment present |
| AIT-3 | MFA recovery after device change | Investigated an admin-console 403, reviewed enrollment policy, enrolled Okta Verify for Windows, tested MFA, reset and re-enrolled it | Successful MFA and dashboard sign-in before reset; reset and subsequent re-enrollment confirmed |
| AIT-4 | Okta Super Administrator request | Reviewed justification and approvals, assessed least privilege and checked Samuel Ortiz's Admin roles tab | Simulated request declined; no individually assigned admin privileges seen; Jira cancellation workflow not completed |

### AIT-1: Application access investigation

The fictional employee reported a missing application, but the initial checks showed an active account, correct AD and Okta group membership and an existing app assignment. I documented that the reported problem was not reproduced.

I then ran a controlled test: removed Samuel Ortiz from `GRP-CLINIC-HAM-FrontDesk` in AD, manually imported the change to Okta and confirmed that the application assignment disappeared while his account remained active. Re-adding the group and importing again restored the group and app assignment.

This was an application **assignment** test using an Okta Bookmark App, not proof of authentication into or enforcement by a production application.

### AIT-2: Employee onboarding

I raised a fictional HR request for Jordan Ellis, a Front Desk Coordinator at Hamilton Clinic. I created the account in AD, assigned `GRP-CORP-AllStaff` and `GRP-CLINIC-HAM-FrontDesk`, and performed an AD import into Okta. Jordan appeared as an active AD-sourced user, with both groups and the Front Desk Portal assigned through the Front Desk group. The Okta trial subsequently reached its 10-active-user limit.

HR authorization was simulated. No production SaaS account provisioning, credential delivery or new-user authentication test was performed.

### AIT-3: MFA enrollment and recovery

The ticket began as a fictional lost-phone report. Inspection showed that Hannah Reid had **no enrolled authenticators**, so the reported recovery problem could not initially be reproduced.

A standard employee sign-in to the Admin Console produced a 403 error indicating no assignment to the client application. Using the employee sign-in route instead, I reviewed the enrollment policy (Okta Verify optional), installed Okta Verify for Windows 11 and enrolled Hannah's lab account.

I verified an Okta System Log event for successful MFA authentication, followed by successful dashboard sign-in. I then reset the Okta Verify enrollment through the Admin Console. The Windows application displayed an MFA-reset warning and offered re-enrollment. Re-enrollment was confirmed in the Admin Console and System Log through successful factor activation and device-add events.

A **fresh post-reset MFA sign-in** was not independently recorded. The exercise simulated recovery of a Windows authenticator, not an actual lost phone.

### AIT-4: Privileged access request

Samuel Ortiz requested ongoing Okta Super Administrator access to troubleshoot one Front Desk application. The request lacked manager and Security approval and did not define an access review or expiration date.

I documented the excessive privilege risk and responded with a least-privilege alternative: have IT troubleshoot the issue, or submit a narrower request with appropriate approvals. Samuel's Admin roles tab showed **no individually assigned administrator privileges**. That check did not establish whether any group-based administrator permissions existed.

No privileges were granted. The fictional review concluded with a decision to decline the request as submitted. Jira's Cancel request dialog required a Resolution value that could not be selected in the lab, so the workflow closure was not confirmed.

## Documentation

- [Test cases and observed results](docs/test-cases.md)
- [Troubleshooting and access-request runbooks](docs/runbooks.md)
- [Evidence inventory](evidence/README.md)

## Evidence gallery

These are cropped screenshots from the lab. The MFA setup QR code is excluded, and System Log event excerpts omit connection IP addresses and detailed identifiers. Click each image to expand. See the [evidence index](evidence/README.md) for a file-by-file description.

### AIT-1 — Application access investigation

<table>
<tr><td width="50%" valign="top"><a href="evidence/AIT-1-01-jira-request.webp"><img src="evidence/AIT-1-01-jira-request.webp" width="425" alt="Reported access issue recorded in Jira"></a><br><sub>Reported access issue recorded in Jira</sub></td><td width="50%" valign="top"><a href="evidence/AIT-1-02-ad-group-removed.webp"><img src="evidence/AIT-1-02-ad-group-removed.webp" width="425" alt="Front Desk group removed in AD"></a><br><sub>Front Desk group removed in AD</sub></td></tr>
<tr><td width="50%" valign="top"><a href="evidence/AIT-1-03-okta-assignment-removed.webp"><img src="evidence/AIT-1-03-okta-assignment-removed.webp" width="425" alt="No app assignment after AD import"></a><br><sub>No app assignment after AD import</sub></td><td width="50%" valign="top"><a href="evidence/AIT-1-04-okta-assignment-restored.webp"><img src="evidence/AIT-1-04-okta-assignment-restored.webp" width="425" alt="Group-based assignment restored"></a><br><sub>Group-based assignment restored</sub></td></tr>
</table>

### AIT-2 — New employee onboarding

<table>
<tr><td width="50%" valign="top"><a href="evidence/AIT-2-01-jira-onboarding.webp"><img src="evidence/AIT-2-01-jira-onboarding.webp" width="425" alt="Simulated HR onboarding request in Jira"></a><br><sub>Simulated HR onboarding request in Jira</sub></td><td width="50%" valign="top"><a href="evidence/AIT-2-02-ad-role-groups.webp"><img src="evidence/AIT-2-02-ad-role-groups.webp" width="425" alt="Jordan's AD role groups"></a><br><sub>Jordan's AD role groups</sub></td></tr>
<tr><td width="50%" valign="top"><a href="evidence/AIT-2-03-okta-groups.webp"><img src="evidence/AIT-2-03-okta-groups.webp" width="425" alt="AD groups reflected in Okta"></a><br><sub>AD groups reflected in Okta</sub></td><td width="50%" valign="top"><a href="evidence/AIT-2-04-okta-app-assignment.webp"><img src="evidence/AIT-2-04-okta-app-assignment.webp" width="425" alt="Front Desk Portal assigned through group"></a><br><sub>Front Desk Portal assigned through group</sub></td></tr>
</table>

### AIT-3 — MFA enrollment and recovery

<table>
<tr><td width="50%" valign="top"><a href="evidence/AIT-3-01-no-enrolled-authenticators.webp"><img src="evidence/AIT-3-01-no-enrolled-authenticators.webp" width="425" alt="Initial state: no enrolled authenticators"></a><br><sub>Initial state: no enrolled authenticators</sub></td><td width="50%" valign="top"><a href="evidence/AIT-3-02-mfa-success-log.webp"><img src="evidence/AIT-3-02-mfa-success-log.webp" width="425" alt="Successful MFA and user login events before reset"></a><br><sub>Successful MFA and user login events before reset</sub></td></tr>
<tr><td width="50%" valign="top"><a href="evidence/AIT-3-03-reset-confirmation.webp"><img src="evidence/AIT-3-03-reset-confirmation.webp" width="425" alt="Administrator-initiated reset acknowledged"></a><br><sub>Administrator-initiated reset acknowledged</sub></td><td width="50%" valign="top"><a href="evidence/AIT-3-04-reenrollment-prompt.webp"><img src="evidence/AIT-3-04-reenrollment-prompt.webp" width="425" alt="Windows Okta Verify requests re-enrollment"></a><br><sub>Windows Okta Verify requests re-enrollment</sub></td></tr>
<tr><td width="50%" valign="top"><a href="evidence/AIT-3-05-reenrolled-authenticator.webp"><img src="evidence/AIT-3-05-reenrolled-authenticator.webp" width="425" alt="New Okta Verify enrollment confirmed"></a><br><sub>New Okta Verify enrollment confirmed</sub></td><td width="50%" valign="top"><a href="evidence/AIT-3-06-reenrollment-log.webp"><img src="evidence/AIT-3-06-reenrollment-log.webp" width="425" alt="Factor activated and device added successfully"></a><br><sub>Factor activated and device added successfully</sub></td></tr>
</table>

### AIT-4 — Privileged-access decision

<table>
<tr><td width="50%" valign="top"><a href="evidence/AIT-4-01-jira-privileged-request.webp"><img src="evidence/AIT-4-01-jira-privileged-request.webp" width="425" alt="Super Administrator request in Jira"></a><br><sub>Super Administrator request in Jira</sub></td><td width="50%" valign="top"><a href="evidence/AIT-4-02-no-individual-admin-roles.webp"><img src="evidence/AIT-4-02-no-individual-admin-roles.webp" width="425" alt="No individual Okta admin roles shown"></a><br><sub>No individual Okta admin roles shown</sub></td></tr>
<tr><td width="50%" valign="top"><a href="evidence/AIT-4-03-jira-cancellation-form.webp"><img src="evidence/AIT-4-03-jira-cancellation-form.webp" width="425" alt="Jira cancellation resolution field blocked closure"></a><br><sub>Jira cancellation resolution field blocked closure</sub></td><td width="50%"></td></tr>
</table>

## What I learned

The support process matters as much as the technical change. For each request, I practiced documenting what I checked, separating a user's report from findings, verifying changes in both AD and Okta, and avoiding unnecessary privilege grants.

I also learned to distinguish successful MFA enrollment from successful authentication, and a successful re-enrollment from a separate post-recovery sign-in test.

## Scope and limitations

This project is a personal lab, not employment experience or a production service desk. Jira employee requests, responses, approvals and escalations were simulated. No real HR or Security team authorized the changes. The Okta Bookmark App does not implement real SSO or production authorization. I used manual AD imports and did not measure response-time SLAs, conduct Mac/MDM troubleshooting or test 40 SaaS applications.

Selected screenshots are published in the evidence gallery. They are cropped to relevant results and omit enrollment QR codes. System Log excerpts have connection IP addresses and detailed identifiers removed.
