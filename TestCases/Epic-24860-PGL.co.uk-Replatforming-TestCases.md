**Epic**: 24860 — PGL.co.uk Re-platforming Support

Note: Each test case below uses ADHD-friendly formatting: no tables, clear headings, numbered steps, and concise expected results.

TC-01 — Redirect: legacy pgl.co.uk -> new target
- Preconditions:
  - Redirect mapping for test URL is provided and deployed to QA.
- Steps:
  1. Open browser and navigate to legacy URL (example: /old-page)
  2. Observe HTTP response and final URL in address bar
  3. Verify status code and redirect type
- Expected:
  - Final URL matches mapping, redirect is 301, landing page loads with correct content and metadata.
- Negative tests:
  - Navigate to non-mapped legacy URL -> verify 404 or sensible fallback.

TC-02 — Content rendering and assets
- Preconditions: page migrated and assets imported.
- Steps:
  1. Open migrated content page.
  2. Confirm hero image, body images, CSS and JS assets load without errors.
 3. Click 3 internal links on the page.
- Expected:
  - Images and styles render correctly, no broken links, links navigate to correct targets.

TC-03 — Metadata and SEO preservation
- Preconditions: migrated page has meta tags set.
- Steps:
  1. Inspect page source for title, meta description, canonical.
  2. Verify robots and canonical tags match expected values.
- Expected:
  - Metadata matches supplied content, canonical points to correct canonical URL.

TC-04 — MyPGL login and session persistence
- Preconditions: Test user exists in MyPGL; SSO/SSO tokens configured.
- Steps:
  1. Navigate to my.pgl.co.uk and log in with test credentials.
 2. Access a form that uses MyPGL authentication.
 3. Log out and log in again.
- Expected:
  - Login successful, session persists across forms, logout invalidates session.
- Negative:
  - Enter incorrect password -> shows correct error message and no session created.

TC-05 — Forms: activity planning and medical info
- Preconditions: Form endpoint reachable in QA; sample data ready.
- Steps:
  1. Open activity planning form.
  2. Fill required fields with valid data and submit.
 3. Validate confirmation message and confirmation email (if applicable).
 4. Repeat submitting with an invalid postcode and expect validation errors.
- Expected:
  - Valid submission accepted, data stored/sent, invalid inputs return inline errors.

TC-06 — Mobile payments page (sales flow)
- Preconditions: Payment provider sandbox ready.
- Steps:
  1. From sales flow, navigate to mobile payments page.
 2. Enter payment details in sandbox mode and submit.
 3. Simulate payment failure and success.
- Expected:
  - Success shows confirmation; failure shows clear error and recovery options.

TC-07 — Postcode locator accuracy
- Preconditions: Postcode lookup service reachable.
- Steps:
  1. Enter valid postcode and verify returned location matches expected.
 2. Enter malformed postcode and verify error handling.
- Expected:
  - Valid postcode returns accurate result; malformed returns validation message.

TC-08 — Cloudflare / App Gateway edge behaviour
- Preconditions: QA routing via Cloudflare/App Gateway configured.
- Steps:
  1. Send request to QA host via public URL.
 2. Verify TLS handshake, response headers, and caching headers.
- Expected:
  - TLS certificate valid, expected headers present, caching behaves per rules.

TC-09 — DNS and SSL verification
- Preconditions: DNS entries for QA/dev/live created.
- Steps:
  1. Resolve hostname via DNS lookup.
 2. Open site and view SSL certificate chain.
- Expected:
  - DNS resolves to expected IPs; SSL chain trusted with correct CN/SAN entries.

TC-10 — Accessibility sample checks (per page type)
- Preconditions: Screen reader and keyboard test tools available.
- Steps:
  1. Open page and navigate using keyboard (Tab order) through main interactive elements.
 2. Run automated axe-core check and record top-level failures.
 3. Test with NVDA/VoiceOver quick read of page headings and form labels.
- Expected:
  - Keyboard access to primary controls, no critical a11y violations, form fields labelled.

TC-11 — Analytics and cookie banner
- Preconditions: Analytics and OneTrust scripts deployed in QA.
- Steps:
  1. Open page in incognito and accept cookies where applicable.
 2. Trigger an event (e.g., click CTA) and confirm analytics event recorded in test GA account.
 3. Decline cookies and verify tracking is disabled.
- Expected:
  - Events logged when cookies allowed; no tracking when declined.

TC-12 — Regression: booking and core shared flows (smoke)
- Preconditions: User and booking test data exist.
- Steps:
  1. Start a booking flow from landing page.
 2. Complete key steps up to booking confirmation (use test sandbox for payments).
- Expected:
  - Booking flow completes without errors and confirmation is generated.

Notes:
- For each TC record environment, build/deploy version, browser and device.
- Log screenshots and reproducible steps for defects.
