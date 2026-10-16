# Test notes and evidence index

| ID | Activity | Observed result | Evidence |
| --- | --- | --- | --- |
| T01 | Check service OU and discover OktaService | OU exists and is empty; OktaService found under default Users container | E01 |
| T02 | Review OktaService group membership and attributes | Domain Users only, non-expiring password, no description | E02 |
| T03 | Create the two service account identities | Both initially disabled, PasswordNeverExpires=False | E03 |
| T04 | Assign backup groups | Backup account in Read and Write groups | E04 |
| T05 | Configure backup test folder permissions | NTFS RX on source, Modify on destination, admin/system retained | E05 |
| T06 | Complete effective access task test | Not verified; account disabled again | E06 |
| T07 | Introduce lab orphan scenario | Retired reporting account enabled with backup groups | E07 |
| T08 | Run inventory detection | 1 potential orphan in three named accounts | E08 + original CSV |
| T09 | Search DC01 and WS01 for service/task dependencies | 0 matching services and 0 matching tasks on each | E09, E10 |
| T10 | Disable orphan identity and remove access | Enabled=False; only Domain Users; post-remediation CSV exported | E11 + post CSV |

## Evidence files

E01-service-account-discovery.png; E02-okta-account-review.png; E03-test-accounts-created.png; E04-backup-group-memberships.png; E05-backup-ntfs-acls.png; E06-backup-account-disabled.png; E07-orphan-account-introduced.png; E08-inventory-orphan-flag.png; E09-dependency-check-dc.png; E10-dependency-check-ws.png; E11-orphan-remediation-verified.png.

Screen captures show selected points in time. The inventory CSV captures the initial flagged state; the post-remediation CSV captures the final state of only `svc-legacy-reports`.