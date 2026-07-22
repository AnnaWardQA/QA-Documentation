**PGL front page header & footer changes — Test Plan & Draft Test Cases (Work Item 26041)**

Source
+ MCP Work Item: `26041` — https://pgltravel.visualstudio.com/Apps/_workitems/edit/26041
+ Description: Header/menu design update. Requirement: logo (top-left) must redirect to the homepage of the individual site it sits on; exception: pgl.co.uk must redirect to pgl.co.uk.

Scope
+ Verify header (logo, menu, submenu behaviors), mobile/hamburger behavior, keyboard and screen-reader accessibility, responsive breakpoints, footer content and links, and resilience under resource failure.

Linked artifacts
+ Work Item: `26041` (see URL above). No additional linked Tasks/PRs/Test Suites were found in this repository; please attach Azure DevOps linked Tasks, Pull Requests and Test Suites to the work item so they can be listed here.

Environments & Repeatable Test Data
+ Staging sites used in tests:
  - https://familyadventures.qa.pgl.co.uk/
  - https://www.qa.pgl.co.uk/
  - https://jobs.qa.pgl.co.uk/
+ Test accounts (staging):
  - Standard user: testuser+ts01@pgl.co.uk / Password1!
  - Admin-type (if available): testadmin+ts01@pgl.co.uk / Password1!
+ Design assets: AssetsForDev.zip (attached to work item)
+ Tools: Chrome (latest), Edge (latest), Firefox (latest), Mobile Chrome (Android), Safari (iOS), NVDA (Windows) or VoiceOver (macOS), Axe/WCAG checker for contrast.

Assumptions
+ Tests run against the staging hostnames above. If a different staging host mapping is required, replace the URLs and re-run tests.

Test Plan Checklist
+ Verify header template deployed to staging for each site.
+ Confirm design assets (AssetsForDev.zip) are accessible.
+ Ensure test accounts exist and can log in on staging.

Test Cases (drafts)

TC-01 — Logo: site-specific redirect (core)
+ Preconditions: Header template deployed to staging on each target host; staging DNS resolves.
+ Test data: Use the three staging hosts above.
+ Steps:
  1. Open https://familyadventures.qa.pgl.co.uk/ in Chrome.
  2. Confirm header loads and PGL logo is visible top-left.
 3. Click the PGL logo.
 4. Observe the final URL and page title.
 5. Repeat steps 1–4 for https://www.qa.pgl.co.uk/ and https://jobs.qa.pgl.co.uk/.
+ Expected results:
  - familyadventures.qa.pgl.co.uk: logo click navigates to https://familyadventures.qa.pgl.co.uk/ (site homepage).
  - www.qa.pgl.co.uk: logo click navigates to https://www.qa.pgl.co.uk/ (site homepage).
  - jobs.qa.pgl.co.uk: logo click navigates to https://jobs.qa.pgl.co.uk/ (site homepage).
+ Test types: Functional, Integration

TC-02 — Menu visual conformance (desktop, 1366×768)
+ Preconditions: Latest CSS/assets deployed; AssetsForDev.zip reference screenshot available.
+ Test data: Chrome desktop with viewport 1366×768.
+ Steps:
  1. Open https://familyadventures.qa.pgl.co.uk/ at 1366×768.
 2. Inspect header menu: spacing, font, icon presence and color.
 3. Capture a screenshot and compare to reference image (pixel or visual diff acceptable within tolerance).
+ Expected results: Visual layout matches reference; fonts, spacing and icons present; no overlap.
+ Test types: UI, Visual regression

TC-03 — Hover / submenu behavior (desktop)
+ Preconditions: Submenu items exist for at least one top-level menu item.
+ Test data: Chrome and Edge on desktop.
+ Steps:
  1. Open https://www.qa.pgl.co.uk/.
 2. Hover the top-level menu item labelled "Holidays" (or equivalent).
 3. Verify submenu appears within 1s.
 4. Move pointer into submenu and confirm it remains visible.
 5. Move pointer away and confirm submenu closes.
+ Expected results: Submenu shows on hover, remains when interacting, and closes on pointer leave; no JS errors in console.
+ Test types: Functional

TC-04 — Mobile: hamburger, expand/collapse and navigation
+ Preconditions: Mobile menu implemented.
+ Test data: Chrome device emulator (375×812) or physical iPhone/Android device.
+ Steps:
  1. Open https://familyadventures.qa.pgl.co.uk/ in mobile viewport.
 2. Tap hamburger icon to open menu.
 3. Tap a parent item to expand children.
 4. Tap a leaf link (e.g., "Activities") and confirm navigation to expected URL (HTTP 200).
 5. Use device back to return and verify the menu state is correct.
+ Expected results: Hamburger toggles menu; parent expands/collapses on tap; links navigate and back returns to previous state.
+ Test types: Functional, Mobile

TC-05 — Keyboard accessibility: focus and navigation
+ Preconditions: Page loaded in desktop browser with keyboard.
+ Test data: Chrome on Windows.
+ Steps:
  1. Open https://www.qa.pgl.co.uk/ and press Tab repeatedly until header/menu gains focus.
 2. With a top-level item focused press Enter to open submenu.
 3. Use Arrow Down/Up to move between submenu items.
 4. Press Enter to activate a submenu link and verify navigation.
 5. Press Esc to close submenu and verify focus returns to the top-level item.
+ Expected results: Logical tab order; Enter/Space opens; Arrow keys navigate; Esc closes; focus moves into main content after header as expected.
+ Test types: Accessibility (keyboard)

TC-06 — Screen reader semantics (NVDA)
+ Preconditions: NVDA installed (Windows) and running.
+ Test data: NVDA and Chrome.
+ Steps:
  1. Start NVDA and open https://familyadventures.qa.pgl.co.uk/.
 2. Navigate to header/menu using NVDA navigation keys.
 3. Confirm ARIA roles and expanded/collapsed states are announced for menus.
 4. Activate a menu item and verify NVDA announces the navigation.
+ Expected results: Menu roles/labels and states announced; menu usable by screen reader.
+ Test types: Accessibility (screen reader)

TC-07 — Focus visibility & contrast
+ Preconditions: Styles applied.
+ Test data: Axe or WCAG contrast checker.
+ Steps:
  1. Tab through header elements and confirm a visible focus indicator is present for each interactive control.
  2. Use a contrast tool on menu text vs background to confirm ratios meet WCAG AA (4.5:1 for normal text).
+ Expected results: Clear focus outlines and contrast ratios meet AA.
+ Test types: Accessibility

TC-08 — Responsive breakpoints & boundary checks
+ Preconditions: Responsive CSS available.
+ Test data: Viewport widths 1280, 1024, 768, 600, 375 and exact boundary tests at 767/769, 599/601.
+ Steps:
  1. Resize to each viewport width and verify header layout and menu behavior.
  2. At each breakpoint test -1px and +1px to catch boundary regressions.
+ Expected results: No overlap, truncation or broken layout at breakpoints; hamburger appears where expected.
+ Test types: Boundary, Regression

TC-09 — Link integrity and navigation
+ Preconditions: Staging pages reachable.
+ Test data: Full menu link list for https://www.qa.pgl.co.uk/ (obtain from sitemap or dev list).
+ Steps:
  1. Click each top-level and submenu link.
  2. Confirm destination returns HTTP 200 and page content matches expected title/heading.
+ Expected results: No 4xx/5xx errors; pages load and match expected targets.
+ Test types: Integration, Regression

TC-10 — Auth-dependent menu items
+ Preconditions: Test accounts exist on staging.
+ Test data: testuser+ts01@pgl.co.uk / Password1! (standard); testadmin+ts01@pgl.co.uk / Password1! (admin)
+ Steps:
  1. On https://www.qa.pgl.co.uk/, confirm menu items visible when signed out.
 2. Log in as testuser+ts01@pgl.co.uk and confirm user-specific menu items appear/hide as designed.
 3. Log out and confirm menu returns to signed-out state.
+ Expected results: Menu content changes reflect authentication and role; logo redirect unaffected.
+ Test types: Functional, Integration

TC-11 — Header config mapping verification
+ Preconditions: Access to CMS or header mapping file; staging header deployed.
+ Test data: Mapping file or CMS entry for logo targets.
+ Steps:
  1. Open header mapping in CMS and confirm logo target URL for each site entry.
 2. On staging, click logo and confirm runtime behavior matches CMS mapping.
+ Expected results: CMS mapping matches runtime redirect targets.
+ Test types: Integration

TC-12 — Negative: JS/CSS failure resilience
+ Preconditions: Ability to block resources in DevTools network conditions.
+ Test data: DevTools rule blocking header JS file.
+ Steps:
  1. Block the header JS resource and reload https://www.qa.pgl.co.uk/.
 2. Confirm essential navigation (logo link, top-level links rendered as anchors) is still reachable.
 3. Capture console errors and ensure errors are logged for dev triage.
+ Expected results: Site degrades gracefully; essential navigation remains reachable where possible.
+ Test types: Negative, Resilience

TC-13 — Footer: content, links, branding and accessibility
+ Preconditions: Footer deployed and assets available.
+ Test data: https://www.qa.pgl.co.uk/ footer link list; contact number: +44 1234 567890 (verify with design)
+ Steps:
  1. Open https://www.qa.pgl.co.uk/ and scroll to footer.
 2. Verify columns, logos, certification badges and phone number are present and match design.
 3. Click each footer link and confirm HTTP 200 and expected target.
 4. On mobile viewport verify tappable areas and stack order.
+ Expected results: Footer matches design, links work, phone tel: operates on mobile.
+ Test types: Functional, Accessibility

Notes / Next steps
+ I cannot automatically fetch linked Tasks/PRs/Test Suites from Azure DevOps from this environment — please attach any related Tasks, Pull Requests or Test Suites to Work Item `26041` and I will ingest them into the test plan.
+ If you want these drafted cases imported into Azure Test Plans, confirm and provide a PAT/vault access or I can export them as a CSV for upload.

---

Edited: added concrete staging URLs and repeatable test accounts; saved here for review.
