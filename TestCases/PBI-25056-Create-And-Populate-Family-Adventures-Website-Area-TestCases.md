# Test Cases — PBI-25056: Create And Populate Family Adventures Website Area

Note: Acceptance criteria and attachments from Azure DevOps are required to finalise expected results and pass/fail conditions. Mark any missing acceptance criteria as BLOCKERS.

Test data: CMS author account, sample family offers (title, description, image, price, booking link), test user account for booking flow.

TC-01: Verify Family Adventures area is visible in main navigation
1. Precondition: User on site homepage.
2. Action: Look for "Family Adventures" in main navigation.
3. Expected: Link is present and clickable.

TC-02: Open listing page and verify required elements
1. Precondition: On Family Adventures listing page.
2. Action: Inspect first 3 items on the list.
3. Expected: Each item has title, short description, thumbnail image, price or price indicator, and a CTA.

TC-03: Apply family-friendly filter
1. Precondition: On listing page with filters visible.
2. Action: Turn on "Family-friendly" filter and apply.
3. Expected: Only family-suitable items remain; count reduces or shows filtered badge.

TC-04: Open detail page and validate content and metadata
1. Precondition: On an item detail page.
2. Actions:
   a. Verify title, full description, image gallery, price, booking CTA are displayed.
   b. Inspect page source or CMS preview for meta title and meta description.
3. Expected: All elements present; metadata fields are populated.

TC-05: CMS authoring flow — create, publish, view
1. Precondition: CMS author logged in.
2. Actions:
   a. Create a new Family Adventures page with mandatory fields filled.
   b. Save as Draft, preview, then Publish.
   c. Visit public site URL for the new page.
3. Expected: Draft preview works; published page visible on site with correct content.

TC-06: Booking CTA leads to expected booking flow
1. Precondition: Detail page with booking CTA.
2. Action: Click booking CTA.
3. Expected: User lands on booking flow or external booking partner page as defined in acceptance criteria.

TC-07: Verify migration script moved pages to AreaId=4
1. Precondition: SQL migration script executed against target environment (staging/test DB) with PageID = 74.
2. Action: Query the `dbo.Page` table for pages where `PageAreaID = 4` and inspect a sample of moved pages; visit pages on familyadventures subdomain.
3. Expected: Pages previously under PageID 74 now have `PageAreaID = 4` and render correctly on the new site.

TC-08: Verify Area settings updated
1. Precondition: AreaId = 4 exists.
2. Action: Query `dbo.Area` and verify `AreaItemType`, `AreaItemTypePageProperty`, `AreaLayout` match expected values, and confirm in CMS UI.
3. Expected: Area settings match the script values and the site uses specified layout.

TC-09: Verify subpage URL behaviour and redirect
1. Precondition: Family Adventures site settings changed to not include parent URL in subpage URLs and redirect first page to '/'.
2. Actions:
   a. Open a child page and confirm its URL does not include parent page segment.
   b. Visit the site root for Family Adventures and confirm it redirects to '/'.
3. Expected: URLs formatted as per requirement and root redirect works.

TC-10: MyPGL login persistence when navigating between domains
1. Precondition: User logged into MyPGL.
2. Action: From MyPGL, navigate to `familyadventures.pgl.co.uk` and back to `my.pgl`.
3. Expected: User remains logged in to MyPGL across navigation. NOTE: Work item indicates this may fail currently — if it fails, log as dependency/defect.

TC-11: Discount codes and payment flow
1. Precondition: Valid discount codes and test payment gateway or test card data available.
2. Action: Apply discount code during booking flow and complete payment using test cards.
3. Expected: Discount applied correctly and payment processes without error; confirmation page shown.

TC-07: Responsive check
1. Precondition: Use mobile/tablet/desktop viewport.
2. Action: Load listing and detail pages on each viewport.
3. Expected: Layout adapts, images scale, CTA remains visible and usable.

Negative Test NC-01: Missing image fallback
1. Precondition: Item with image field empty in CMS.
2. Action: Publish page.
3. Expected: Page loads with a placeholder image and no layout break.

Negative Test NC-02: Long title handling
1. Precondition: Item title > 200 characters.
2. Action: Publish and view detail page.
3. Expected: Title wraps or truncates gracefully; layout not broken.

Accessibility Checks
- A11Y-01: Keyboard navigation — Tab through listing and detail pages; ensure focus order logical and CTAs reachable.
- A11Y-02: Screen reader — Verify ARIA labels for images and CTAs.
- A11Y-03: Contrast — Verify colour contrast for all CTAs and body text meets WCAG AA.

Negative Tests (additional)
- NC-03: Run migration script with incorrect PageID — verify script does not affect other areas and roll back.
- NC-04: Publish page with missing required metadata (meta title/description) — verify warning or fail state in CMS and rendering behaviour.

Traceability
- Map each test case to acceptance criteria once provided. Tests without matching acceptance criteria should be flagged as needing clarification.
