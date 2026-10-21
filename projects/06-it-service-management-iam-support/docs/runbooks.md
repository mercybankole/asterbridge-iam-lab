# IT support runbooks

These are the steps I used to guide the support scenarios in this project.

## Application access issue

1. Record the application, error, affected employee and business impact in Jira.
2. Check the employee's account status in AD and Okta.
3. Check the AD group, its membership in Okta and the source of the application assignment.
4. Review recent changes and run an authorized AD import when needed.
5. Correct the group membership at its source, then verify the assignment again.
6. Record the findings and the employee-facing update in Jira.

## MFA enrollment or recovery

1. Confirm the employee's identity using the approved support process.
2. Check account status, authenticator enrollment and the relevant Okta policies.
3. Review the error and System Log before making a change.
4. For an approved reset, select only the affected authenticator.
5. Guide enrollment on the replacement or authorized device.
6. Confirm enrollment and have the employee sign in again; inspect the resulting authentication events.
7. Record the action, verification and any unresolved issue in Jira.

## Privileged access request

1. Record the requested system, role, reason and access duration.
2. Check whether manager and Security approvals are present.
3. Compare the requested role with the specific task and existing permissions.
4. If the role is excessive or authorization is missing, withhold access and explain what is needed.
5. Consider a narrower role or have IT carry out the task directly.
6. Record the decision, access status and any outstanding approvals in Jira.
