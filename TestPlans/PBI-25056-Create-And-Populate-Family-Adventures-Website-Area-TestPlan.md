# Test Plan — PBI-25056: Create And Populate Family Adventures Website Area

MCP Work Item: PBI-25056 (Azure DevOps link required)

Note: I do not have access to the Azure DevOps work item details. Fill in the "Work Item Details" section below or provide the DevOps URL/attachments so I can update these documents with exact acceptance criteria, attachments and discussion notes.

## Work Item Details
- Title: Create And Populate Family Adventures Website Area
- Owner: (from DevOps)
- Related Links/Attachments:
  - Pgl website recommendations.docx: https://hbed-my.sharepoint.com/:w:/r/personal/craig_nellist_pglbeyond_com/Documents/Desktop/Pgl%20website%20recommendations.docx
  - familyadventures.pgl.co.uk
- Acceptance Criteria (from work item):
  - Create the new area "Family Adventures" as AreaId = 4 before creating MyPGL so script ids remain consistent.
  - Move existing Family Adventures pages (root PageID = 74) into the new Area (AreaId 4) using provided SQL script.
  - Apply new Area settings (AreaItemType, AreaItemTypePageProperty, AreaLayout) via SQL.
  - For Family Adventures site settings, disable inclusion of parent URL in subpage URLs and enable "Redirect first page to /".
  - Verify links across site (internal/external) function and nothing breaks.
  - Verify MyPGL login persistence when navigating between familyadventures and my.pgl (note: current comment indicates this may fail).
  - Verify booking flows, discount codes and payments operate without errors (use test cards or mock gateways as required).


## Requirements Analysis
- Summary: Create a new website area called "Family Adventures" and populate it with pages/content, navigation and metadata as specified by Product.
- Functional requirements (derived / to validate):
  - Area exists under main site navigation.
  - Pages for tours/experiences are present with title, description, images, prices, and booking CTA.
  - Category and filtering for family-friendly offers.
  - SEO metadata populated (title, meta description, canonical URL).
  - Content editable in CMS and renders correctly on desktop/mobile.

## Test Approach
- Scope: Focus on feature functionality, content correctness, navigation, CMS publish flow, accessibility and regression for related sections.
- Types of testing:
  - Functional
  - End-to-end (site navigation + booking CTA flows)
  - Regression (impact on header/footer, search, related categories)
  - Accessibility (WCAG AA checks)
  - Cross-browser and responsive testing
  - Negative and edge-case testing
  - Migration and configuration verification (SQL script validation, area settings)

## Manual Steps / Migration Steps (from work item)
- Step 1: Create a new website area for Family Adventures (AreaId = 4). Ensure this is created before MyPGL so script ids still match.
- Step 2: Move the pages under Family Adventures to the new site. Run the following T-SQL to move the page hierarchy (root PageID = 74):

```
WITH PageHierarchy AS (
    SELECT PageID FROM dbo.Page WHERE PageID = 74
    UNION ALL
    SELECT p.PageID FROM dbo.Page p INNER JOIN PageHierarchy ph ON p.PageParentPageID = ph.PageID
)
UPDATE p
SET p.PageAreaID = 4
FROM dbo.Page p INNER JOIN PageHierarchy ph ON p.PageID = ph.PageID;
```

- Step 3: Add settings to the new Area:

```
UPDATE dbo.Area
SET AreaItemType = 'Additional_Website_Settings',
    AreaItemTypePageProperty = 'PGL_Page',
    AreaLayout = 'Designs/PGLCore/Corporate Home Page.htm'
WHERE AreaId = 4;
```

- Step 4: On the Family Adventures website settings:
  - Disable inclusion of parent URL in subpage URLs for this area.
  - Enable "Redirect first page to /".
  - (See work item images for guidance.)

## Acceptance Criteria Mapping
- AC: Create AreaId=4 before MyPGL -> Test: Verify Area exists and MyPGL creation not yet performed.
- AC: Page move script applied to PageID 74 -> Test: All pages formerly under PageID 74 show AreaId=4 in DB and render on familyadventures subdomain.
- AC: Area settings updated -> Test: Area record fields match expected values.
- AC: URL settings and redirect configured -> Test: Subpage URLs omit parent section and root redirects to '/'.
- AC: Booking/login/discount/payment -> Test: End-to-end booking flow, MyPGL login persistence, discount codes and payment acceptance tested in staging.

## Risks, Gaps and Recommendations (updated)
- Risk: Running SQL scripts on production without a backup may cause content to be orphaned — ensure DB backup and change window.
- Gap: Work item notes that MyPGL login persistence currently fails — this is a dependency and may block full acceptance testing for booking flows.
- Recommendation: Schedule migration during a low-traffic window and validate on staging first; ensure rollback scripts are prepared.

## Test Coverage Matrix (high-level)
- Navigation: new area link, breadcrumbs, header/menu impact
- Content pages: presence of required elements, images, metadata
- CMS publish: draft -> publish -> live content
- Filtering/search: family-friendly filter
- Booking CTA: click-through leads to booking or correct external flow
- SEO fields: metadata present and correct
- Accessibility: keyboard navigation, alt-text, color contrast

## Test Scenarios
- S1: Family Adventures area appears in main navigation and opens to listing page.
- S2: Listing page displays items with required fields and filters work.
- S3: Detail page shows images, description, price, booking CTA and metadata.
- S4: CMS author can create/edit/publish a Family Adventures page and see changes live.
- S5: Booking CTA leads to booking flow (or expected external page).
- S6: Responsive layout for desktop/tablet/mobile.
- S7: Accessibility checks for screen readers and keyboard-only use.
- S8: Negative data cases (missing image, long title, broken link) handled gracefully.

## Regression Impact Analysis
- Areas to run regression tests against:
  - Site header/footer
  - Global search
  - Category pages and filters
  - Related content widgets

## Risks, Gaps and Recommendations
- Risk: Acceptance criteria not provided or ambiguous around booking flow -> block for test sign-off.
- Gap: No test data provided for sample family offers (images, prices) — request from Product/CMS team.
- Recommendation: Request a checklist from Content team confirming required fields for each page before UAT.

## Test Environment and Dependencies
- Environments: Dev, Staging, Production (specify URLs)
- CMS access required for authoring tests
- Test accounts for booking (if payment involved) or mock endpoints

## Execution Checklist
1. Confirm acceptance criteria from DevOps work item.
2. Provision test data and CMS test user.
3. Sanity test on Dev environment.
4. Execute feature tests and record results.
5. Execute accessibility checks.
6. Execute regression smoke tests.
7. Log defects and retest fixes.
8. Prepare UAT pack and hand over to BA/Product for sign-off.

## Sign-off Criteria
- All acceptance criteria have tests marked Passed.
- No Severity 1/2 defects open.
- UAT sign-off recorded.

---
_Update this file after providing the Azure DevOps URL or on receipt of the work item details._
