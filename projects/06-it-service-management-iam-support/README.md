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

## What I learned

The support process matters as much as the technical change. For each request, I practiced documenting what I checked, separating a user's report from findings, verifying changes in both AD and Okta, and avoiding unnecessary privilege grants.

I also learned to distinguish successful MFA enrollment from successful authentication, and a successful re-enrollment from a separate post-recovery sign-in test.

## Scope and limitations

This project is a personal lab, not employment experience or a production service desk. Jira employee requests, responses, approvals and escalations were simulated. No real HR or Security team authorized the changes. The Okta Bookmark App does not implement real SSO or production authorization. I used manual AD imports and did not measure response-time SLAs, conduct Mac/MDM troubleshooting or test 40 SaaS applications.

Screenshots are being collected and reviewed before publication so that authenticator secrets, tokens and unrelated account details are not disclosed.
