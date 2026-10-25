# Project 07 — Test and troubleshooting record

I recorded the failures and corrections below while building the Okta–Salesforce SAML integration. This is the sequence I want to be able to explain in a technical interview.

## Foundation: Set up the integration

| Stage | Action | Observed result | Next action |
| --- | --- | --- | --- |
| Salesforce organization | Created Developer Edition, identified Organization ID and My Domain | Actual service provider environment available | Added Salesforce.com from Okta catalog |
| Okta integration | Selected SAML 2.0, active SHA-2 certificate | Okta generated identity provider metadata | Imported metadata into Salesforce |
| Metadata import | Entered Okta metadata URL in Salesforce | Error: `Specify a public URL from Remote Site Settings.` | Added active Okta Remote Site entry and retried |
| Metadata import retry | Reused identical metadata URL | Salesforce populated SAML configuration | Checked issuer, certificate, Entity ID and identity matching |
| Salesforce SAML setting | Saved `Okta Asterbridge SSO` | Login URL generated | Copied Salesforce login URL to Okta and configured domain |

## Baseline sign-in

| Stage | Symptom or test | Investigation and action | Verified outcome |
| --- | --- | --- | --- |
| Okta password | `Bad request` during Jordan's verification | Realized AD domain controller was powered off; powered it on | Reached the next authentication check |
| Okta password change | `Password change is currently restricted by organization policy` | Inspected Jordan's AD account, found `User must change password at next logon`, addressed the requirement | Jordan signed into the Okta dashboard |
| Salesforce first attempt | Generic Salesforce SSO error | Login History showed `SAML IdP Initiated SSO`, `Configuration Error/Perm Disabled`; checked and enabled org-wide SAML | Jordan entered Salesforce; Login History showed Success |
| Second employee | Hannah added to Okta Salesforce group with app-specific Salesforce username | Tested in a separate employee session | Hannah entered Salesforce |

## Scenario 2: Missing app tile

- Baseline: Jordan could see Salesforce and sign in.
- Fault introduced: Removed Jordan from `APP-Salesforce-Sales`.
- Observation: Salesforce disappeared from his Okta dashboard; Front Desk Portal remained.
- Diagnosis: Jordan no longer had the group-based application entitlement.
- Correction: Restored group membership, checked the app-specific username.
- Verification: Salesforce tile returned and Jordan accessed Salesforce again.

## Scenario 3: Invalid Salesforce username in the SAML Subject

- Baseline: Jordan could enter Salesforce.
- Fault introduced: Changed Jordan's Okta Salesforce application username to `jellis@mydomain.com`; actual Salesforce username stayed `jordan.ellis@asterbridge.ca`.
- Observation: Generic Salesforce Single Sign-On Error. No matching new failure entry was visible in Login History.
- Diagnostic escalation: Opened **SAML Assertion Validator**.
- Specific evidence: `Subject: jellis@mydomain.com`; `Unable to map the subject to a Salesforce user`.
- Correction: Restored `jordan.ellis@asterbridge.ca` in the application-specific username field.
- Verification: Fresh Okta-initiated SSO succeeded.

## Scenario 4: Shared issuer mismatch

- Baseline: Jordan and Hannah could each authenticate to Salesforce.
- Fault introduced: Changed the issuer in the common Salesforce SAML setting to `invalid-issuer-asterbridge-test`.
- Observation: Salesforce SSO error after Okta authentication.
- Diagnostic evidence: Salesforce Assertion Validator reported `Response's issuer did not match the issuer configured in the Single Sign-On Setting`.
- Actual Okta issuer: `exk193ouiw90XAwFP698`.
- Correction: Restored the issuer shown in the Okta Salesforce application's Sign On details.
- Verification: Both Hannah and Jordan returned to their Salesforce Seller Home pages.

## Scenario 5: Salesforce Campaign permissions

- Baseline: Hannah could access Salesforce and open Campaigns, but **New** wasn't visible.
- Attempted change: Enabled Hannah's **Marketing User** account setting.
- Observation: **New** still wasn't visible.
- Further check: Standard User profile showed Campaigns **Read**, but not **Create** or **Edit**.
- Correction: Created `Asterbridge Campaign Creator` with **Read / Create / Edit**; left **Delete / View All / Modify All** ungranted.
- Assignment: Hannah only, expiring October 31, 2026.
- Verification: The **New** button appeared. Hannah created `Asterbridge Q4 Sales Outreach – LAB`.

## How I separate the failure types

| User report | Where I look first |
| --- | --- |
| Can't sign into Okta at all | Okta authentication, source directory and relevant account state |
| App tile is missing | Okta group membership and application assignments |
| Tile present, Salesforce sign-in fails | Application-specific username, Okta SSO events, Salesforce Login History and SAML Validator |
| Many people fail at once | Shared SAML configuration and recent integration changes |
| Salesforce opens but action is unavailable | Salesforce license, profile, permission sets and account-level settings |

I didn't rely on a successful configuration save alone. For each recovery, I returned to the employee's session and tested the action that had originally failed.
