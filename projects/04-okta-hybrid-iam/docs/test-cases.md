# Test Cases and Results

The tests were carried out against the Asterbridge lab AD domain (`mydomain.com`) and an Okta trial. Screenshots are listed in the [evidence index](../evidence/README.md).

| ID | Test | Expected | Observed | Result | Evidence |
| --- | --- | --- | --- | --- | --- |
| T01 | Register the Okta AD Agent and set up the directory integration | Okta recognizes the AD domain | Setup completed for `mydomain.com` | Passed | E01 |
| T02 | Run the initial full import | In-scope identities and groups appear in Okta | 8 new users and 8 groups imported | Passed | E02, E03 |
| T03 | Test AD delegated authentication for Hannah Reid | AD credentials are accepted | Okta returned `Active Directory authentication successful!` | Passed | E04, E05 |
| T04 | Assign the Bookmark App to `GRP-CLINIC-HAM-FrontDesk` | Samuel receives an application assignment through his group | Assignment type shown as `Group` | Passed | E06, E07 |
| T05 | Remove Samuel from the AD group, then run a full import | Okta removes the membership and group-based app assignment | Okta group contained 0 people; app showed no users | Passed | E08, E09 |
| T06 | Restore Samuel's AD group membership, then import | App assignment returns | Samuel appeared with assignment type `Group` | Passed | E10 |
| T07 | Disable Samuel in AD and run a full import | Okta deactivates the AD-sourced identity | Import reported 1 user removed; Samuel's Okta status was `Deactivated` | Passed | E11, E12 |
| T08 | Re-enable Samuel in AD and repeat the import | Original Okta account becomes active again | Initial confirmation failed while account remained `INACTIVE`; after enabling the reactivation setting and importing again, status became `Active` | Passed after configuration change | E13 |
| T09 | Check restored app access after reactivation | Samuel regains group-based app assignment | Samuel appeared on the app's Assignments tab with type `Group` | Passed | E14 |

## Notes

- Samuel Ortiz and Hannah Reid are fictional test accounts.
- The test application was a Bookmark App, not a working clinical application. Assignment and unassignment in Okta were verified; application-side authorization was not.
- Each membership or lifecycle change was followed by a manual full import. Scheduled import behavior and timing were not tested.
- Samuel's deactivated Okta account was retained, rather than deleted. His restoration reused that account.
- The AD Agent installer warned that `OktaService` was not in the Pre-Windows 2000 Compatible Access group. User and group imports worked in these tests, but the warning was not separately investigated.
