# Findings and remediation

## NHI-F01: Retired service account retained access

- Category: Orphaned non-human identity / unnecessary access
- Nature: Deliberately introduced lab scenario
- Account: `svc-legacy-reports`
- Initial evidence: `Service-Account-Inventory.csv`, E07 and E08
- Initial state: Enabled; backup Read and Write memberships; description says retired reporting application and unassigned owner
- Risk: An enabled account with no current business purpose could be misused if its credentials were obtained. Backup group memberships would extend the potential exposure to files protected by those groups.
- Dependency check: No matching Windows services or scheduled tasks on DC01 and WS01 (E09, E10). Other application and host dependencies were not assessed.
- Simulated decision: Decommission the test identity, retaining the disabled account for reference
- Action taken: Disabled the AD account and removed the backup Read and Write group memberships
- Verification: AD reported Enabled=False and Domain Users only; `Orphan-PostRemediation.csv` and E11
- Final state: Remediated within tested AD scope
- Severity: Medium, assigned for this training scenario; not a formal organizational risk rating

## NHI-OBS01: OktaService documentation and password handling

- Evidence: `Service-Account-Inventory.csv`, E01 and E02
- Observed: Account enabled; Domain Users group; blank Description field; PasswordNeverExpires=True; no SPN listed in the checked attribute.
- Limit: Group membership alone does not establish full effective permissions or local rights. Password rotation practice was not verified. The Okta Agent installation warning documented in Project 04 was not resolved here.
- Follow-up: Confirm which service or installation process uses the account, record an accountable owner and credential rotation process, and investigate necessary access on the Azure VM before changing it.
- Status: Observation only; not remediated in this exercise.

## NHI-OBS02: Backup identity test incomplete

- Evidence: E03-E06, `Service-Account-Inventory.csv`
- Observed: Backup groups were assigned; test folder ACLs were configured; `svc-clinic-backup` was disabled again after work on the scheduled-task test.
- Limit: No verified results showing permitted reads/writes and denied source modifications under the service identity. Windows Task Scheduler and temporary batch-logon-right cleanup were not independently confirmed.
- Follow-up: If the backup exercise is revisited, run an auditable task as the service identity, capture results, and verify that the temporary task and user right were removed.
- Status: Configuration documented; effectiveness not concluded.

## Decision and evidence boundaries

All approvals and application-retirement details for `svc-legacy-reports` are fictional scenario assumptions. The account changes were performed in the lab. No real owner signed a certification or approved the decommissioning. An absence of matched tasks/services on two machines is not proof of an organization-wide lack of dependencies.