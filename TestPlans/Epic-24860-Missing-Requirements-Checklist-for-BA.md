Missing / Ambiguous Requirements — Checklist for BA / Dev

Use: Copy and paste into a Word doc or the ticket description.

Hi team,

We need quick answers to the items below so QA can write final tests and sign off. Short, concrete replies please.

1) Redirect mapping
- Provide full legacy URL list and exact target URL for each.
- Specify redirect type (301/302) and rule for query strings, UTM and fragments.

2) Acceptance criteria
- Give measurable pass/fail criteria (examples: redirect coverage %, top 20 pages no broken links, accessibility target met).

3) SEO & metadata
- Confirm title/meta handling, canonical tags, sitemap/robots expectations, and any structured data needs.

4) Performance targets
- State page load targets (LCP/TTFB), acceptable error rates and peak concurrency expectations.

5) Analytics & cookie consent
- Provide GA property IDs, list of events to track, OneTrust categories, and behaviour when cookies are declined.

6) Accessibility
- Confirm WCAG target (e.g., WCAG 2.1 AA) and any agreed exceptions or SLAs for remediation.

7) Forms
- Confirm which forms move where, submission endpoints, validation rules, confirmation email templates and data storage location.

8) MyPGL / SSO
- Document SSO flow, session timeout, token handling and provide test accounts.

9) Payments
- Provide payment provider, sandbox credentials, test card data and expected success/failure flows.

10) Environments, DNS & SSL
- List exact hostnames for dev/QA/preprod/live and who will provision DNS and SSL.

11) Cloudflare / App Gateway / CDN rules
- Provide page rules, caching policy, cache purge process and TTLs.

12) IIS / backend bindings
- Confirm IIS bindings, backend pool targets and routing rules.

13) Redirect edge cases
- Decide on trailing slash rules, case sensitivity and whether to preserve query params or UTM tags.

14) Rollback plan
- Provide rollback steps, who can trigger rollback and target RTO/RPO.

15) Test access & data
- Provide QA/dev URLs, test accounts, sample test data and refresh cadence.

16) UAT scope & owners
- List the top pages for UAT, the content owner for each page and the sign-off workflow.

17) Monitoring & KPIs
- Define post-release metrics to monitor (5xx rate, crawl errors, conversions) and incident contacts.

18) Third-party tags
- List all marketing/tracking tags and note if any require consent or special handling.

19) Legacy backups & assets
- Confirm backup strategy for media/attachments and how large assets will be migrated/verified.

20) Security & compliance
- Note GDPR/data retention requirements, security scans required and remediation timelines.

Thanks — a short answer under each item is perfect. If any item is "TBD" please add an owner and target date.
