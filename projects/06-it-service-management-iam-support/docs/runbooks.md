# Troubleshooting and Access Request Runbooks

These procedures describe controlled support workflows for the Asterbridge lab, not a production organization's approved procedures.

## Runbook 1: User cannot see an assigned Okta application

**Intake:** Record user, application, impact, onset, error message and whether multiple users are affected.

**Verify:** Confirm the requester's identity using an approved method before any account change. Check AD account status, relevant AD groups, Okta account status, synchronized group membership and the application assignment source. Compare against an access matrix or approval.

**Investigate:** Check recent group/assignment changes and relevant Okta events. Determine whether the assignment is direct or group-based; check whether an AD import has run. Do not assume a missing tile means application authentication itself failed.

**Remediate:** Restore only authorized group-based access at the source of truth; import/synchronize as appropriate. Escalate unexpected or unauthorized privilege changes.

**Validate:** Confirm app assignment returns and, for a real integrated application, have the requester test access. Keep assignment verification separate from production app sign-in. Add internal notes and a user-facing update; close only against a supported resolution.

## Runbook 2: User cannot complete MFA / lost authenticator

**Intake:** Record device availability, exact challenge, last successful login, and urgency without asking for passwords, codes or recovery secrets.

**Identity verification:** Follow the organization's approved recovery method before resetting factors. An email or chat request alone is not sufficient.

**Investigate:** Check account status, authenticator enrollment, applicable enrollment and authentication policies, and relevant System Log events. Distinguish 403 admin-app authorization issues from incorrect-password or MFA problems.

**Remediate:** If approved, reset only the unavailable authenticator, not unrelated security methods. Guide the user through enrollment on an authorized compatible device; avoid changing global policy to make one case pass.

**Validate:** Confirm new enrollment in Okta, successful new sign-in with the recovered factor, and corresponding System Log events. If the fresh post-reset test was not run, state that limitation explicitly.

**Escalate:** Suspicious login history, inability to verify identity, missing compliant device, policy constraints, or repeated unexplained failures require the Security/IAM team.

## Runbook 3: Privileged access request

**Intake:** Capture requested system, specific work to be performed, role, justification, manager, approval evidence and required duration.

**Evaluate:** Compare scope to job responsibilities and least privilege. Confirm correct approving authority and whether existing IT Support can perform the task without granting requester admin privileges.

**Decision:** Withhold access if approval is missing or role is excessive. Seek a narrower time-bound role when justified and approved. Never provision a Super Administrator role solely for single-application troubleshooting.

**Verify:** Review direct and group-based role sources where applicable; record changes and approval evidence. In the AIT-4 exercise, only individual admin assignments were inspected.

**Close or escalate:** Communicate decision, retain an audit trail and accurately record whether the ticket was declined, left pending, or successfully transitioned. Do not claim an approval or Jira closure that was not performed.
