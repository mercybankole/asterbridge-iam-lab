# Project 07: Okta–Salesforce SAML SSO & Access Troubleshooting

I connected Okta to Salesforce Developer Edition and tested employee access, SSO failures and Salesforce permissions using two fictional Sales employees, Jordan Ellis and Hannah Reid.

Tools: Okta, Salesforce Developer Edition, SAML 2.0, Salesforce Login History and SAML Assertion Validator.

## Setup — Connecting Okta to Salesforce

1. I found the Salesforce Organization ID and My Domain, added `Salesforce.com – Asterbridge` from the Okta App Catalog, selected SAML 2.0 and used the active SHA-2 signing certificate.

   <a href="evidence/02-okta-salesforce-app.webp"><img src="evidence/02-okta-salesforce-app.webp" width="610" alt="Okta Salesforce SAML integration and certificate settings"></a>

2. In Salesforce → Setup → Single Sign-On Settings, I tried **New from Metadata URL** using Okta's metadata link. Salesforce returned `Specify a public URL from Remote Site Settings`. I added the Okta domain under Remote Site Settings and retried the import.

   <a href="evidence/18-metadata-import-remote-site-error.webp"><img src="evidence/18-metadata-import-remote-site-error.webp" width="610" alt="Salesforce metadata import error requesting Remote Site Settings"></a>

3. I reviewed the imported issuer, certificate, Entity ID and HTTP POST binding, saved `Okta Asterbridge SSO`, and entered the Salesforce login URL and custom domain in Okta.

   <a href="evidence/01-saml-setup.webp"><img src="evidence/01-saml-setup.webp" width="610" alt="Configured Salesforce SAML identity provider settings"></a>

## Scenario 1 — Onboard Sales employees and test SSO

1. I created Jordan and Hannah as Salesforce Standard Users. Their Salesforce usernames were `jordan.ellis@asterbridge.ca` and `hannah.reid@asterbridge.ca`.

   <a href="evidence/03-salesforce-user-jordan.webp"><img src="evidence/03-salesforce-user-jordan.webp" width="610" alt="Jordan's Salesforce user account"></a>

2. I created the Okta group `APP-Salesforce-Sales`, assigned the Salesforce application to it, and added Jordan and Hannah. Okta showed their app assignments as `Group`.

   <a href="evidence/04-okta-group-assignment.webp"><img src="evidence/04-okta-group-assignment.webp" width="610" alt="Salesforce application assignments inherited from the Okta Sales group"></a>

3. Their Okta logins used `@mydomain.com`. I kept group-managed assignment but set each Salesforce application username to the matching `@asterbridge.ca` account.

   <a href="evidence/05-username-override.webp"><img src="evidence/05-username-override.webp" width="610" alt="Per-user Salesforce application username override while keeping group ownership"></a>

4. Jordan's first Okta sign-in failed with `Bad request`. I discovered the AD domain controller was off and powered it on. The next attempt showed a password-change policy restriction; I checked his AD account's `User must change password at next logon` setting, addressed the password-change issue and retried.

   <a href="evidence/06-okta-password-policy-error.webp"><img src="evidence/06-okta-password-policy-error.webp" width="610" alt="Jordan's Okta password-change policy error"></a>

5. Jordan reached Okta, but Salesforce showed a Single Sign-On Error. Salesforce Login History showed `SAML IdP Initiated SSO — Configuration Error/Perm Disabled`. I enabled SAML in Salesforce's organization-wide Single Sign-On Settings and retried.

   <a href="evidence/07-salesforce-sso-disabled.webp"><img src="evidence/07-salesforce-sso-disabled.webp" width="610" alt="Salesforce Login History showing SAML configuration error"></a>

6. Jordan reached Salesforce without entering another password. I checked Login History again and found a successful SAML login. I also tested Hannah's Salesforce SSO successfully.

   <a href="evidence/08-salesforce-sso-success.webp"><img src="evidence/08-salesforce-sso-success.webp" width="610" alt="Successful SAML IdP Initiated SSO event in Salesforce Login History"></a>

## Scenario 2 — Salesforce tile missing in Okta

1. I removed Jordan from `APP-Salesforce-Sales`. After refreshing his Okta dashboard, Salesforce disappeared while his Front Desk Portal stayed visible.

   <a href="evidence/09-salesforce-tile-removed.webp"><img src="evidence/09-salesforce-tile-removed.webp" width="610" alt="Jordan's Okta dashboard after Salesforce group access was removed"></a>

2. I checked Okta → Salesforce application → Assignments, restored Jordan's group membership, and confirmed his group-based assignment and Salesforce application username.
3. I refreshed Jordan's dashboard, saw Salesforce return and opened it successfully.

## Scenario 3 — Salesforce rejects a valid Okta user

1. I deliberately changed Jordan's Salesforce application username in Okta from `jordan.ellis@asterbridge.ca` to `jellis@mydomain.com`. His real Salesforce username was unchanged.
2. Okta sign-in worked, but Salesforce returned a Single Sign-On Error. Login History didn't show a useful new failure, so I opened Salesforce → Single Sign-On Settings → SAML Assertion Validator.
3. The validator showed `Subject: jellis@mydomain.com` and `Unable to map the subject to a Salesforce user`. I compared it with Jordan's Salesforce username and found the mismatch.

   <a href="evidence/10-saml-subject-mismatch.webp"><img src="evidence/10-saml-subject-mismatch.webp" width="610" alt="SAML Assertion Validator showing the unmapped subject"></a>

4. I restored `jordan.ellis@asterbridge.ca` in the Okta application assignment and confirmed SSO worked again.

## Scenario 4 — Shared Salesforce SSO configuration failure

1. With Jordan and Hannah both able to sign in, I recorded the correct issuer, then changed Salesforce's shared SAML Issuer to `invalid-issuer-asterbridge-test` to reproduce an integration problem.

   <a href="evidence/11-issuer-config-break.webp"><img src="evidence/11-issuer-config-break.webp" width="610" alt="Changed the issuer in the Salesforce SAML configuration"></a>

2. Salesforce rejected SSO. In the SAML Assertion Validator, I found `Response's issuer did not match the issuer configured in the Single Sign-On Setting`. Okta was sending `exk193ouiw90XAwFP698`.

   <a href="evidence/12-saml-issuer-mismatch.webp"><img src="evidence/12-saml-issuer-mismatch.webp" width="610" alt="SAML Assertion Validator identifying the incorrect issuer"></a>

3. I copied the original issuer from Okta → Salesforce application → Sign On → More details, restored it in Salesforce and saved.
4. I tested separate sessions for Jordan and Hannah. Both reached their Salesforce Seller Home pages.

   <a href="evidence/19-both-users-recovered.webp"><img src="evidence/19-both-users-recovered.webp" width="610" alt="Jordan and Hannah both back in Salesforce after restoring the issuer"></a>

## Scenario 5 — SSO works, but Hannah cannot create campaigns

1. Hannah could open Salesforce → Campaigns, but there was no `New` button. I enabled **Marketing User** on her Salesforce account, refreshed, and still couldn't see `New`.
2. I checked her Standard User profile. Campaign permissions allowed `Read`, but not `Create` or `Edit`; those standard profile permissions weren't editable.

   <a href="evidence/13-salesforce-profile-read-only.webp"><img src="evidence/13-salesforce-profile-read-only.webp" width="610" alt="Standard User profile had Campaign Read but not Create or Edit"></a>

3. I created the permission set `Asterbridge Campaign Creator` with Campaign `Read`, `Create` and `Edit`. I left `Delete`, `View All` and `Modify All` disabled.

   <a href="evidence/14-permission-set-scoped.webp"><img src="evidence/14-permission-set-scoped.webp" width="610" alt="Scoped Campaign permission set with Read Create and Edit"></a>

4. I assigned the permission set only to Hannah, with an expiration of October 31, 2026.

   <a href="evidence/15-timebound-assignment.webp"><img src="evidence/15-timebound-assignment.webp" width="610" alt="Successful permission set assignment to Hannah with expiration date"></a>

5. I refreshed Hannah's Campaigns page. The `New` button appeared.

   <a href="evidence/16-new-campaign-button.webp"><img src="evidence/16-new-campaign-button.webp" width="610" alt="New Campaign button available to Hannah after the permission change"></a>

6. I clicked `New` and created `Asterbridge Q4 Sales Outreach – LAB` with status `Planned`.

   <a href="evidence/17-campaign-created.webp"><img src="evidence/17-campaign-created.webp" width="610" alt="Salesforce campaign successfully created by Hannah"></a>
