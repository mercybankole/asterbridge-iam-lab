# Script review and improvements

The PowerShell scripts in this repository are the original tested lab versions. They have not been rewritten after execution. They are **not production-ready**.

| Script | Tested behavior | Improvement opportunities |
| --- | --- | --- |
| `New-AsterbridgeJoiner.ps1` | Creates disabled account, resets password, assigns groups, enables account | Post-step verification, richer validation, failure cleanup, structured logs and approval checks |
| `Move-AsterbridgeEmployee.ps1` | Updates Olivia's clinic groups and office, verifies new state | Parameters for other employees, approval workflow, rollback/recovery for partial errors, idempotency |
| `Remove-AsterbridgeLeaver.ps1` | Disables Olivia, removes specified AD groups, moves account to Disabled Users | Full entitlement reconciliation, session revocation, application/Entra/Okta deactivation, timestamps and audit trails |

## Observed troubleshooting

An earlier offboarding attempt reported an Employee ID mismatch; a later elevated run succeeded. The exact cause of the earlier mismatch has not been independently established. The successful run and subsequent verification were documented. It would be inaccurate to conclude that elevation alone explained an ID mismatch.

## Recommended follow-up

Add request/approval records, structured before/after exports, `-WhatIf` support where appropriate, explicit error status, safe partial-failure recovery, duplicate-account testing and account/session revocation across connected services. Keep any revised scripts in a separate version and retest them before claiming new results.

## Evidence discipline

Screenshots are cropped for readability. Fictional Asterbridge company context is distinguished from real lab execution on October 12, 2026; no actual healthcare or payment information was used.
