# UAT Pack — PBI-25056: Create And Populate Family Adventures Website Area

Purpose: Provide a concise, actionable pack for Business/BA/Product to run acceptance tests and sign-off.

Preconditions
- Provide Azure DevOps work item link and final acceptance criteria.
- Provide sample content items (at least 3 family offers) and CMS credentials for authoring.
- Test environment URL (staging) and expected data refresh cadence.

- Migration prerequisites:
  - Backup database before running migration scripts.
  - Ensure AreaId = 4 is created and reserved for Family Adventures before MyPGL area creation.
  - Coordinate a deployment window with Platform/DB teams.

UAT Technical Steps (for platform/DB engineer)
1. Create Area record for Family Adventures (AreaId = 4).
2. Run PageHierarchy migration script for PageID = 74 to move pages to `PageAreaID = 4` (see script below).
3. Update Area settings using provided SQL.
4. Change Family Adventures website settings: disable parent URLs in subpages and enable "Redirect first page to /".

Migration script:

```
WITH PageHierarchy AS (
    SELECT PageID FROM dbo.Page WHERE PageID = 74
    UNION ALL
    SELECT p.PageID FROM dbo.Page p INNER JOIN PageHierarchy ph ON p.PageParentPageID = ph.PageID
)
UPDATE p
SET p.PageAreaID = 4
FROM dbo.Page p INNER JOIN PageHierarchy ph ON p.PageID = ph.PageID;

UPDATE dbo.Area
SET AreaItemType = 'Additional_Website_Settings',
    AreaItemTypePageProperty = 'PGL_Page',
    AreaLayout = 'Designs/PGLCore/Corporate Home Page.htm'
WHERE AreaId = 4;
```

UAT Test Runs (updated)
- Run 1: Navigation and listing validation
  1. Open staging homepage.
  2. Confirm "Family Adventures" visible in main navigation.
  3. Click to open listing page and visually validate sample items.

- Run 2: Migration verification (platform/DB)
  1. Confirm AreaId = 4 exists.
  2. Verify pages with original parent PageID = 74 now report `PageAreaID = 4`.
  3. Confirm pages render on `familyadventures.pgl.co.uk`.

- Run 3: Content validation
  1. Open 3 sample detail pages.
  2. Verify title, description, images, price and booking CTA match content spec.

- Run 4: End-to-end booking verification
  1. Click booking CTA on an item.
  2. Validate that flow follows the expected booking process (mock or live) and returns confirmation page if applicable.

UAT Test Runs
- Run 1: Navigation and listing validation
  1. Open staging homepage.
  2. Confirm "Family Adventures" visible in main navigation.
  3. Click to open listing page and visually validate sample items.

- Run 2: Content validation
  1. Open 3 sample detail pages.
  2. Verify title, description, images, price and booking CTA match content spec.

- Run 3: CMS verification (content owner)
  1. Login to CMS as content author.
  2. Edit an item, change a field, publish.
  3. Confirm change visible on staging within expected publish window.

- Run 4: End-to-end booking verification
  1. Click booking CTA on an item.
  2. Validate that flow follows the expected booking process (mock or live) and returns confirmation page if applicable.

Acceptance Checklist (for BA/Product)
- Navigation link present and correct.
- Listing shows required elements for each item.
- Detail pages show full content and metadata.
- Booking CTA works as defined in acceptance criteria.
- No critical visual or functional defects present.

- Migration & Config Checklist:
  - AreaId = 4 created prior to MyPGL.
  - Migration script executed successfully and verified.
  - Area settings updated and verified in CMS.
  - Subpage URL behaviour and root redirect verified.


Sign-off Template
- UAT Tester: 
- Environment: 
- Date: 
- Tests executed: (list test runs)
- Issues found: (link to defects)
- UAT Status: Approve / Reject
  - Notes:

Known Limitations / Notes
- If booking involves payment, UAT should use test card data or mock payment gateway.
- Accessibility audit results should be attached separately.
