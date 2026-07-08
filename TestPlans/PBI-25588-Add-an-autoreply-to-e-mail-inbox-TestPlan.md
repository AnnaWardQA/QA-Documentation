# Test Plan — PBI 25588: Add an autoreply to e-mail inbox

- **PBI ID:** 25588
- **Title:** Add an autoreply to e-mail inbox
- **Project:** pgltravel
- **Work Item:** https://pgltravel.visualstudio.com/Apps/_workitems/edit/25588
- **Iteration:** Default

## Objective

Validate that the system sends an automatic reply from the target inbox when an incoming email is received, per the acceptance criteria for PBI 25588.

## Acceptance Criteria

- An automatic reply is sent when the autoreply feature is enabled for the inbox.
- The autoreply content matches the configured template.
- Autoreply behavior respects any specified exclusions (e.g., internal addresses, distribution lists) — (confirm with product owner and update tests).

## Scope

- In scope: sending autoresponses from the configured inbox when enabled; verifying content and occurrences.
- Out of scope: creating or configuring the autoreply in Azure DevOps or backend deployment steps (this is a functional test document only).

## Test Environment

- Environment: (specify environment: e.g., QA / Staging)
- Test inbox: (email address / mailbox to use)
- Test sender accounts: external@example.com, internal@example.local

## Preconditions

1. Tester has access to the test inbox and any admin UI required to enable/disable autoreply.
2. Autoreply template/content is available (copy paste into the template below if provided by product owner).

## Test Data

- Sender: external@example.com
- Sender: internal@example.local
- Sample incoming email subject: "Test — autoreply"

## Test Cases

### TC-25588-01 — Autoreply is sent when enabled
- **Objective:** Verify an automatic reply is sent when the autoreply is enabled.
- **Steps:**
  1. Ensure autoreply is enabled for the test inbox and template is set.
  2. From `external@example.com`, send an email to the test inbox with subject `Test — autoreply`.
  3. Wait for the autoreply to be delivered.
- **Expected:** An autoreply is received by `external@example.com` and contains the configured message/template.
- **Notes:** Record the autoreply subject/body and timestamp.

### TC-25588-02 — No autoreply when disabled
- **Objective:** Verify no autoreply is sent when the feature is disabled.
- **Steps:**
  1. Disable autoreply for the test inbox.
  2. From `external@example.com`, send an email to the test inbox.
- **Expected:** No autoreply is received.

### TC-25588-03 — Autoreply exclusion rules
- **Objective:** Verify exclusions (if any) prevent autoreply.
- **Steps:**
  1. Confirm exclusion rules with product owner (e.g., internal domains, distribution lists).
  2. From `internal@example.local`, send an email to the test inbox.
- **Expected:** No autoreply is sent to excluded/internal addresses.

### TC-25588-04 — Autoreply frequency control (once per sender)
- **Objective:** Verify the system does not send repeated autoreplies to the same sender within the configured timeframe (if applicable).
- **Steps:**
  1. Enable autoreply and send an email from `external@example.com` to receive the first autoreply.
  2. Send a second email from the same sender within the configured suppression window.
- **Expected:** A second autoreply is not sent within the suppression window (confirm expected window with product owner).

## Expected Results / Exit Criteria

- All in-scope test cases pass.
- Any failures are documented as defects with reproduction steps and logs.

## Post-test Cleanup

- Restore autoreply setting to previous state (enable/disable as appropriate).

## Notes / Questions for PO

- Confirm exact autoreply template text and any exclusion rules.
- Confirm suppression/window behavior for repeated sends.

---
_Generated locally based on PBI link and title; fill in any missing product specifics before execution._
