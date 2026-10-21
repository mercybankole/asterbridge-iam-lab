# Evidence inventory — Project 06

These 17 screenshots were taken during the Asterbridge IT service desk simulation and then cropped to the relevant findings. They are linked in the [project README](../README.md).

The original images remain with the lab notes; the public versions exclude the MFA enrollment QR code, unnecessary account details and connection IP addresses in the log excerpts. All employee identities and Jira requesters in these cases are fictional or simulated.

| Ticket | Evidence file | What it demonstrates |
| --- | --- | --- |
| AIT-1 | [AIT-1-01-jira-request.webp](AIT-1-01-jira-request.webp) | Reported access issue recorded in Jira |
| AIT-1 | [AIT-1-02-ad-group-removed.webp](AIT-1-02-ad-group-removed.webp) | Front Desk group removed in AD |
| AIT-1 | [AIT-1-03-okta-assignment-removed.webp](AIT-1-03-okta-assignment-removed.webp) | No app assignment after AD import |
| AIT-1 | [AIT-1-04-okta-assignment-restored.webp](AIT-1-04-okta-assignment-restored.webp) | Group-based assignment restored |
| AIT-2 | [AIT-2-01-jira-onboarding.webp](AIT-2-01-jira-onboarding.webp) | Simulated HR onboarding request in Jira |
| AIT-2 | [AIT-2-02-ad-role-groups.webp](AIT-2-02-ad-role-groups.webp) | Jordan's AD role groups |
| AIT-2 | [AIT-2-03-okta-groups.webp](AIT-2-03-okta-groups.webp) | AD groups reflected in Okta |
| AIT-2 | [AIT-2-04-okta-app-assignment.webp](AIT-2-04-okta-app-assignment.webp) | Front Desk Portal assigned through group |
| AIT-3 | [AIT-3-01-no-enrolled-authenticators.webp](AIT-3-01-no-enrolled-authenticators.webp) | Initial state: no enrolled authenticators |
| AIT-3 | [AIT-3-02-mfa-success-log.webp](AIT-3-02-mfa-success-log.webp) | Successful MFA and user login events before reset |
| AIT-3 | [AIT-3-03-reset-confirmation.webp](AIT-3-03-reset-confirmation.webp) | Administrator-initiated reset acknowledged |
| AIT-3 | [AIT-3-04-reenrollment-prompt.webp](AIT-3-04-reenrollment-prompt.webp) | Windows Okta Verify requests re-enrollment |
| AIT-3 | [AIT-3-05-reenrolled-authenticator.webp](AIT-3-05-reenrolled-authenticator.webp) | New Okta Verify enrollment confirmed |
| AIT-3 | [AIT-3-06-reenrollment-log.webp](AIT-3-06-reenrollment-log.webp) | Factor activated and device added successfully |
| AIT-4 | [AIT-4-01-jira-privileged-request.webp](AIT-4-01-jira-privileged-request.webp) | Super Administrator request in Jira |
| AIT-4 | [AIT-4-02-no-individual-admin-roles.webp](AIT-4-02-no-individual-admin-roles.webp) | No individual Okta admin roles shown |
| AIT-4 | [AIT-4-03-jira-cancellation-form.webp](AIT-4-03-jira-cancellation-form.webp) | Jira cancellation resolution field blocked closure |

## Interpretation notes

- **AIT-1:** The initial reported missing app was not independently reproduced. Group removal and restoration demonstrate **Okta Bookmark App assignment** changes, not production app authentication.
- **AIT-2:** The new user was provisioned in AD and imported into Okta; HR authorization was fictional and no production SaaS app was provisioned.
- **AIT-3:** System Log captures verified MFA success *before* reset and successful factor activation / device registration *after* re-enrollment. A separate post-recovery MFA login was not independently recorded. The original lost-phone scenario was not reproduced.
- **AIT-4:** The Okta Admin roles tab demonstrated no **individually** assigned admin roles, not a complete audit of group-derived privileges. The simulated Super Administrator request was declined; Jira's cancellation workflow was not completed.

Screenshots should not be presented as proof of employment or production access control, and no real approval or incident took place.
