**Epic**: 24860 — PGL.co.uk Re-platforming Support — UAT Pack

**Purpose**:
- Provide instructions and artefacts for Product/Content owners to perform UAT and sign-off.

**Scope for UAT**:
- Validate content correctness and taxonomy for migrated pages.
- Validate redirects for a core set of high-traffic URLs.
- Validate form flows used by sales and schools/groups.
- Validate login and account access for MyPGL-related flows.

**Entry Criteria**:
- QA regression passed for critical flows in QA environment.
- Redirect rules deployed to QA environment.
- Content owner and Product available for test session.

**Exit Criteria**:
- All P0/P1 issues resolved or have an agreed mitigation.
- Content sign-off completed by Content owner.
- Product sign-off for go-live.

**UAT Roles & Contacts**:
- UAT Coordinator: Product / PO
- Content owner: Content Team
- QA support: QA Engineer (test execution support)
- Ops contact: Tony/Andy/Craig as required for DNS/SSL/App Gateway

**Test Sessions & Checklist (for UAT tester)**:
- Pre-session:
  1. Confirm you have credentials for MyPGL test account.
  2. Confirm the list of URLs you will validate (supply your selected top 20 pages).
- Session activities:
  1. Follow Scenario: Open legacy URL -> observe redirect -> review landing page content.
  2. Open a sample migrated content page -> verify copy, images, links, attachments.
  3. Complete a sample form (activity planning or medical info) and verify confirmation.
  4. Test payments flow via sandbox (if applicable to your role).
  5. Check the cookie banner: accept/decline and verify tracking behaviour.
  6. Perform basic accessibility checks: keyboard navigation and readable headings.
- Post-session:
  1. Record any defects in the tracker with steps and screenshots.
  2. Mark items as Accepted / Needs Work in the UAT log.

**UAT Test Data**:
- Provide a list of sample accounts and form inputs for testers. Example: test1@example.com, postcode samples, sample booking data.

**Sign-off Template**:
- UAT Test Date: ______
- Tester: ______
- Pages tested (list):
- Issues found (IDs):
- Overall Acceptance: Accept / Conditional Accept / Reject
- Notes & Conditions for go-live:

**Known Limitations (to inform UAT)**:
- Some low-traffic pages may not be migrated in the first wave — verify only known migrated list.
- SEO redirects outside the core set may be handled post-launch.
