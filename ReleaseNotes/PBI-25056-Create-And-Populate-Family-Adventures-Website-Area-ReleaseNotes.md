# Release Notes — PBI-25056: Create And Populate Family Adventures Website Area

Summary
- Adds a new "Family Adventures" website area with listing and detail pages for family-friendly experiences. Includes CMS authoring and necessary metadata fields.

Features Delivered
- Main navigation entry for Family Adventures.
- Listing page with filters and item cards.
- Detail pages with image gallery, description, price, booking CTA and SEO metadata.
- CMS publish workflow for content authors.

Acceptance Criteria Coverage
- Create Family Adventures area as AreaId = 4 before MyPGL so script ids remain consistent.
- Move existing Family Adventures pages (root PageID = 74) to AreaId = 4 using provided SQL migration script.
- Update Area settings (`AreaItemType`, `AreaItemTypePageProperty`, `AreaLayout`) via SQL.
- Configure Family Adventures website settings: do not include parent URL in subpage URLs; enable "Redirect first page to /".
- Verify links, MyPGL login persistence, booking flows, discount codes and payment processing.

Deployment Notes
- Deploy to web app slot `staging` then promote to `production` after UAT sign-off.
- CMS content should be synced/seeded as per Content team's checklist.

Important Migration Notes
- Run the PageHierarchy script (PageID = 74) to update `PageAreaID` to 4 for all child pages. Back up DB first.
- Update the `dbo.Area` record for AreaId = 4 as shown in work item SQL.
- Create AreaId = 4 before creating the MyPGL area to keep script ids stable.

Rollback Plan
- Revert feature toggle or configuration that exposes the Family Adventures area.
- Restore previous routing or navigation config from last known good deployment.

Known Issues / Limitations
- MyPGL login persistence across domains is noted in discussion as likely to fail currently; this is a dependency and may block booking confirmation tests.
- Placeholder: list any defects or visual edge cases discovered during testing.

Post-release Checks
- Confirm navigation visible on production.
- Smoke test 3 sample items on production.
- Validate analytics tagging for new area.
