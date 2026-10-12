# Joiner, mover and leaver test cases

**Lab:** `mydomain.com` on Windows Server 2022 (`DC`) and Windows 10 Pro (`CLIENT1`), running in VirtualBox.  
**Test date:** October 12, 2026. **Identity:** `MYDOMAIN\obennett` (`LAB-JML-001`), fictional.

| Test | Method and expected outcome | Evidence | Result |
| --- | --- | --- | --- |
| JML-T01 | Run joiner script, verify account enabled and corporate/Hamilton groups assigned | JML-E01 | Passed |
| JML-T02 | Sign in before transfer, write/read Hamilton and fail writing Kitchener | JML-E02 | Passed |
| JML-T03 | Run mover script; remove Hamilton/add Kitchener and update office attribute | JML-E03 | Passed |
| JML-T04 | Sign in again; write/read Kitchener and deny Hamilton write/read | JML-E04 | Passed |
| JML-T05 | Run leaver script; verify disabled account, group removals, Disabled Users OU | JML-E05 | Passed |
| JML-T06 | Attempt fresh login after directory offboarding; expect account disabled | JML-E07 | Passed |

## Authentication observation

The user was still observed in a Windows session after Active Directory account disabling. Later testing confirmed domain-controller discovery and LDAP connectivity (JML-E06), and an explicit fresh sign-in was rejected (JML-E07). The evidence does not prove the reason for the earlier session behavior.

## Boundaries

Tests involved a synthetic identity and local NTFS folders on a lab workstation. No live patient information, payment records, production application permissions, Entra ID, Okta or cloud-session revocation was tested.
