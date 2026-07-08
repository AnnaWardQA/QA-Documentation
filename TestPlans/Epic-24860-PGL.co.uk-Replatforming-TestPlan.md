**Title**: Epic 24860 — PGL.co.uk Re-platforming Support

**Purpose**:
- Provide QA strategy and test plan for replatforming pgl.co.uk to WordPress (Option 2) and related site changes.

**Scope**:
- Sites and applications impacted: pgl.co.uk main site, MyPGL (my.pgl.co.uk), families.pgl.co.uk, forms/myPGL forms, mobile payments page, postcode locator, repository of customer docs, and shared shortcuts.
- Infrastructure: DNS, SSL, Cloudflare, Application Gateway, IIS.
- Content migration for pages moved to other sites (About Us, Blog, Policy Documents, Schools & Groups support pages).

**Assumptions & Constraints**:
- Option 2 (WordPress) selected; design decisions pending with Claire Harwood.
- Ops teams to provide DNS, SSL and Cloudflare configurations.
- Access to test/dev environments will be provided for functional and performance testing.

**Requirements Analysis (derived from work-items and notes)**:
- Support migration of dynamic site content to WordPress while keeping MyPGL and other subdomains where required.
- Maintain or implement core redirects from old pgl.co.uk URLs to new WordPress URLs or other sites.
- Preserve analytics and cookie policy implementation (Google Analytics, OneTrust).
- Ensure secure delivery (SSL) and correct DNS entries for dev/QA/live.
- Ensure Cloudflare and Application Gateway rules applied; IIS config compatible with new platform.

**Missing / Ambiguous Requirements (action required)**:
- No explicit acceptance criteria were included in the Epic text provided. Please supply or confirm:
  - Full list of URLs to be migrated and canonical redirect mapping.
  - Expected SEO/metadata preservation requirements.
  - Performance targets (page load times, TTFB) for live site.
  - Exact analytics events and cookie categories to be implemented.
  - Accessibility conformance level (WCAG 2.1 AA assumed unless stated).

**Test Approach**:
- Phased testing: Smoke -> Functional -> Integration -> Accessibility -> Performance -> Regression -> UAT.
- Environments: Dev (content staging), QA (integration testing), Pre-Prod (close to live), Prod (post-release verification).
- Roles: QA engineers for functional checks, Accessibility SME for a11y testing, DevOps for infra verification, Content team for content acceptance, Product/PO for UAT sign-off.

**Test Types**:
- Functional: content rendering, forms, search, navigation, redirects.
- Integration: MyPGL interactions, payments pages, postcode locator.
- Security: SSL config, secure headers, cookie settings.
- Accessibility: screen reader flow, keyboard navigation, colour contrast.
- Regression: core flows for booking, account access, forms used by schools/groups.
- Performance: basic load checks for high-traffic pages.

**Test Coverage Matrix (feature -> test focus)**:
- Content pages: rendering, metadata, links, canonical tags, SEO redirects.
- Redirects: correctness, redirect type (301), link preservation.
- MyPGL integration: SSO/session persistence, form submissions, data storage.
- Forms: validation, submission success, error handling, confirmation emails.
- Payments page: load, correct payment provider integration, failure states.
- Postcode locator: lookup accuracy, edge postcode handling.
- Infrastructure: DNS resolution, SSL chain, Cloudflare edge behavior, App Gateway routing, IIS bindings.
- Analytics & Cookies: pageview triggers, event tracking, cookie banner behaviour.

**Test Scenarios (high level)**:
- Scenario 1: Visitor navigates to legacy pgl.co.uk URL and is redirected to the correct new target.
- Scenario 2: Content editors publish migrated page and assets appear without broken links.
- Scenario 3: MyPGL authentication and forms continue to function after platform change.
- Scenario 4: Payments and postcode lookup pages operate correctly from sales flows.
- Scenario 5: Accessibility checks on representative pages (home, content, form, checkout).

**Execution Checklist**:
- Confirm list of migrated pages and redirect mapping.
- Confirm test environment DNS and SSL are provisioned.
- Validate Cloudflare/App Gateway rules in QA.
- Run smoke tests on Dev after content import.
- Run full regression in QA environment.
- Run accessibility pass and log issues.
- Run UAT with content owners and product.

**Risks, Gaps & Recommendations**:
- Risk: Missing redirect mappings cause SEO loss — recommend content/SEO team provide canonical list.
- Gap: Acceptance criteria absent — request PO to provide measurable criteria.
- Recommendation: Hold a pre-migration run with a small set of pages to validate the full release pipeline.
- Recommendation: Capture and version redirect rules in source control and create an automated verify step in QA.

**Sign-off Criteria**:
- All critical functional tests pass in QA.
- Redirect verification completed for core pages.
- Accessibility findings resolved or agreed with PO for exceptions.
- Ops confirm DNS/SSL/Cloudflare/App Gateway/IIS config applied and verified.
- UAT sign-off from Content owner and Product.

**Artifacts**:
- Link to this Test Plan (TestPlans/Epic-24860-PGL.co.uk-Replatforming-TestPlan.md)
- Test Cases: TestCases/Epic-24860-PGL.co.uk-Replatforming-TestCases.md
- UAT Pack: UAT-Test-Packs/Epic-24860-PGL.co.uk-Replatforming-UAT-Pack.md
- Release Notes: ReleaseNotes/Epic-24860-PGL.co.uk-Replatforming-ReleaseNotes.md
