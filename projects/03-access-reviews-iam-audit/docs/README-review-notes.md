# Project 03: Review notes

## Source evidence

The four CSV snapshots under the data folder were exported from the lab on October 14, 2026. The original test and remediation are supported by nine screenshots in the evidence folder.

- AD-Access-Inventory.csv: nine users within the Asterbridge OU, with named GRP-* memberships.
- Access-Certification-Baseline.csv: clean comparison, nine matches.
- Access-Certification-Exception.csv: eight matches and one deliberate excess-membership exception for hreid.
- Access-Certification-PostRemediation.csv: nine matches after the membership was removed.
- Simulated-Role-Baseline.csv: derived reference matrix, not evidence of management approval.

The separate Privileged-Access-Inventory.csv and duplicate Access-Certification.csv remain in the private working files, not this public package. The internal workbook retains these records.

## Review decision rules

Match means the captured GRP-* memberships match the simulated role baseline. Exception means there are differences. Needs baseline indicates an unrecognized account. Every ReviewerDecision value remains Pending. Technical comparison is not management certification.

## Controlled finding IAM-F03

We deliberately assigned the Hamilton Front Desk group to a Kitchener test employee. The review detected the excessive membership, and after a new Windows login the employee could create and read a Hamilton test file. We then removed the membership and signed in again. The Hamilton file was denied while the authorized Kitchener file remained readable. Final certification matched nine of nine records.

This was a controlled lab scenario, not a real incident.

## Scope

The comparison covers user accounts under the Asterbridge OU and groups whose names begin GRP-; it does not evaluate every domain group or application. The privileged-access inventory was a separate read-only exercise. No real patient information was used, and no HR or manager approval process was performed.

## PowerShell reference

Export-ADAccessCertification.ps1 reconstructs the approach followed in the interactive lab. The standalone script has not been run as a single tested artifact. Review and test it in an isolated environment before using its results as audit evidence.
