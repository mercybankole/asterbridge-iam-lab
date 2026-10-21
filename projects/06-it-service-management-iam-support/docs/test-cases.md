# Test results

I recorded the steps and outcomes from the four Jira requests. Screenshots are linked in the [evidence gallery](../README.md#evidence-gallery).

| Ticket | What I tested | Result |
| --- | --- | --- |
| AIT-1 | Checked Samuel's AD and Okta account, groups and Front Desk Portal assignment | Account and access assignments were already correct |
| AIT-1 | Removed Samuel from the Front Desk group in AD and imported the change | Okta removed the group membership and the application assignment |
| AIT-1 | Restored the AD group and imported again | Okta restored the group membership and application assignment |
| AIT-2 | Created Jordan in AD and added AllStaff and Front Desk groups | Account and memberships appeared in AD |
| AIT-2 | Imported Jordan into Okta | Account was active and the Front Desk Portal was assigned through the group |
| AIT-3 | Checked Hannah's existing authenticators | None were enrolled |
| AIT-3 | Tried employee access using the Admin Console address | Received a 403; switching to the employee URL opened enrollment |
| AIT-3 | Enrolled Okta Verify on Windows and signed in | Okta System Log recorded successful MFA and dashboard login |
| AIT-3 | Reset and re-enrolled Okta Verify | Reset confirmed; new enrollment, factor activation and device registration succeeded |
| AIT-4 | Reviewed request for Super Administrator access | Missing approvals and broader permissions than needed; request declined in the simulation |
| AIT-4 | Checked Samuel's individual Okta admin role assignments | No individual admin roles were assigned |
| AIT-4 | Tried to cancel the Jira request | Required Resolution field did not work, so Jira closure was left incomplete |

## Follow-up

I did not run a new MFA sign-in after Hannah's re-enrollment. The AIT-4 admin roles check covered individual assignments only. The Jira cancellation issue is still open.
