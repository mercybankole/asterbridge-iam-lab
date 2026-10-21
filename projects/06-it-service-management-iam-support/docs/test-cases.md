# Test cases and results

All employees, requests and approvals are fictional. Outcomes refer to observations made in the isolated Asterbridge lab.

| Case | Initial state / condition | Actions | Observed result | Limitation |
| --- | --- | --- | --- | --- |
| AIT-1-A | Samuel active in AD/Okta, Front Desk group and Bookmark App assigned | Checked account and assigned groups | Initial access configuration matched role | Reported issue not reproduced |
| AIT-1-B | Expected Front Desk AD group present | Removed group, manually imported AD changes | Group and Okta application assignment disappeared; identity remained active | Bookmark App assignment only |
| AIT-1-C | Group and assignment absent | Restored group, imported AD changes | Group and application assignment returned | No real app login tested |
| AIT-2-A | Fictional approved onboarding scenario | Created Jordan Ellis in AD and applied AllStaff and FrontDesk groups | Groups visible in AD | HR authorization simulated |
| AIT-2-B | New AD account | Imported to Okta, checked identity/groups/app | Active AD-sourced user, both groups present, Bookmark App assigned by FrontDesk group | No credential handover or app login tested |
| AIT-3-A | Hannah active in Okta | Checked Reset Authenticators dialog | No enrolled authenticators | Initial lost-phone report not reproduced |
| AIT-3-B | Standard user attempted admin login | Inspected 403 callback; switched to employee login | Employee sign-in route reached Okta Verify enrollment | 403 cause inferred from client assignment error |
| AIT-3-C | Okta Verify enabled, optional in default enrollment policy | Enrolled Hannah in Okta Verify for Windows 11 | Enrollment shown in admin dialog, device BANKOLE | This was Windows enrollment, not phone recovery |
| AIT-3-D | Authenticator enrolled | Signed in as Hannah, reviewed System Log | MFA success event at 13:25:18 and Okta login success at 13:25:23 on Oct 21, 2026 | FastPass-specific mechanism not independently established |
| AIT-3-E | Existing Okta Verify enrollment | Admin reset, re-enrolled through Windows application, reviewed System Log | Reset success notification; new enrollment present; factor activation and device-add events succeeded at 16:54:03 | No separately evidenced post-recovery MFA sign-in |
| AIT-4-A | Super Administrator request; no manager or Security approval | Assessed business justification, least privilege and duration | Fictional request declined as submitted | No real approvals or Security escalation |
| AIT-4-B | Samuel's existing Okta identity | Inspected Admin roles tab | No individually assigned administrator roles | Does not independently exclude group-derived admin roles |
| AIT-4-C | Jira service request | Attempted Cancel request workflow | Cancellation not completed because required Resolution selection did not work | Jira ticket closure unverified |

## Evidence status

See [Evidence inventory](../evidence/README.md). Screenshot images are not yet published in this folder. Only attach images actually captured, with secrets and unnecessary identifiers removed.

## Status terminology

- **Verified**: directly observed in UI or logs.
- **Simulated**: fictional request, authorization, approval or business event.
- **Not verified**: a procedure or outcome that was not independently tested.
