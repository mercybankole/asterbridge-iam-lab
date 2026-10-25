# Project 07 — Evidence index

I cropped the screenshots to show the settings, errors and results I actually tested. Personal email addresses and source IP values were hidden in the shared evidence.

## SAML integration and employee setup

- [18-metadata-import-remote-site-error.webp](18-metadata-import-remote-site-error.webp) — Salesforce rejected the metadata URL because the Okta domain needed an active Remote Site Settings entry.
- [01-saml-setup.webp](01-saml-setup.webp) — Saved Salesforce SAML configuration with the imported identity provider settings.
- [02-okta-salesforce-app.webp](02-okta-salesforce-app.webp) — Configured the Salesforce application's Sign On settings and certificate in Okta.
- [03-salesforce-user-jordan.webp](03-salesforce-user-jordan.webp) — Created Jordan as an active Salesforce Standard User.
- [04-okta-group-assignment.webp](04-okta-group-assignment.webp) — Both employees assigned through the Okta group rather than directly.
- [05-username-override.webp](05-username-override.webp) — Mapped Jordan's Okta application username to his actual Salesforce username.

## Initial sign-in troubleshooting

- [06-okta-password-policy-error.webp](06-okta-password-policy-error.webp) — Okta reported a password-change restriction for the AD-sourced employee.
- [07-salesforce-sso-disabled.webp](07-salesforce-sso-disabled.webp) — Salesforce Login History showed Configuration Error/Perm Disabled on the first SAML attempt.
- [08-salesforce-sso-success.webp](08-salesforce-sso-success.webp) — A later Salesforce Login History entry showed successful SAML IdP Initiated SSO.

## Lost application assignment and SAML identity mismatch

- [09-salesforce-tile-removed.webp](09-salesforce-tile-removed.webp) — Removing Jordan from the access group removed the Salesforce tile.
- [10-saml-subject-mismatch.webp](10-saml-subject-mismatch.webp) — SAML Validator showed an unmapped Subject when Okta sent jellis@mydomain.com.

## Shared SSO outage and recovery

- [11-issuer-config-break.webp](11-issuer-config-break.webp) — Deliberately set an incorrect issuer in the shared Salesforce SAML configuration.
- [12-saml-issuer-mismatch.webp](12-saml-issuer-mismatch.webp) — Salesforce Validator identified the issuer mismatch between Okta and Salesforce.
- [19-both-users-recovered.webp](19-both-users-recovered.webp) — Two separate sessions after restoring the issuer: Hannah and Jordan both reached Salesforce.

## Salesforce permissions and final verification

- [13-salesforce-profile-read-only.webp](13-salesforce-profile-read-only.webp) — Hannah's Standard User profile allowed Campaign Read, but not Create or Edit.
- [14-permission-set-scoped.webp](14-permission-set-scoped.webp) — The Campaign Creator permission set granted Read, Create and Edit without Delete or broad access.
- [15-timebound-assignment.webp](15-timebound-assignment.webp) — Assigned the permission set only to Hannah, expiring October 31, 2026.
- [16-new-campaign-button.webp](16-new-campaign-button.webp) — The New button appeared after the effective permission changed.
- [17-campaign-created.webp](17-campaign-created.webp) — Hannah created Asterbridge Q4 Sales Outreach – LAB, proving the approved action worked.

