**Epic**: 24860 — PGL.co.uk Re-platforming Support

**Release Summary**:
- Objective: Replatform pgl.co.uk to WordPress (Option 2) and move/support related subsites and functionality.
- Included work items (as provided):
  - 26130, 25056, 25057, 25062, 25058, 26443, 26041, 26343, 26350, 25702, 25874

**What Changed**:
- Core pgl.co.uk site content migrated to WordPress.
- MyPGL remains on my.pgl.co.uk with required integrations preserved.
- Families site remains on families.pgl.co.uk.
- Forms may be hosted on forms.pgl.co.uk or remain under MyPGL depending on final design decisions.
- Redirects implemented for core legacy URLs to new targets.
- DNS entries, SSL certs and Cloudflare rules applied for dev/QA/Live per ops tasks.

**Deployment Notes for Ops**:
- DNS:
  - Create new dev/qa/live records as agreed. Validate DNS propagation in QA before switching traffic.
- SSL:
  - Provision and install certificates for new hostnames. Verify full chain on public endpoints.
- Cloudflare & App Gateway:
  - Apply page rules and caching policies. Confirm caching headers and cache purge strategy.
- IIS:
  - Ensure correct bindings for internal apps and that the App Gateway routes to expected backend pools.

**Rollback Plan**:
- If critical issues are found post-release, perform the following:
  1. Re-apply previous redirect rules and DNS records to point to legacy infrastructure.
  2. Disable Cloudflare rules that route to new environment.
  3. Notify stakeholders and start hotfix plan.

**Known Issues**:
- SEO redirect list incomplete — content/SEO team to supply full mapping post-release.
- Some low-traffic legacy pages may not be migrated in initial release.

**Testing Summary**:
- QA: Functional, integration and regression checks completed for core flows (bookings, MyPGL login, forms, payments sandbox).
- Accessibility: Sample pages checked; major a11y issues resolved; remaining low-impact items logged.
- UAT: Content owners to complete final acceptance.

**Action Items Post-Release**:
- Monitor analytics and Search Console for crawl/SEO errors.
- Review redirect coverage and add missing mappings.
- Validate user feedback channels for broken links or missing content.

**Contacts**:
- Product/PO: (Product contact)
- Content owner: (Content team contact)
- Ops: Tony, Andy, Craig
- QA lead: (QA contact)
