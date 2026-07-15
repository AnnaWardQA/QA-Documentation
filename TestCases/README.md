# Test Execution Guide — Login Session Across Subdomains

Purpose
- Provide concise, repeatable instructions to execute the consolidated test cases for Task 26464 (login session shared across subdomains).

Files
- `Login_Session_Across_Subdomains.docx` — Consolidated test cases and step-by-step instructions.

Prerequisites
- Access to staging environment(s) where cookie config can be adjusted (Domain, SameSite, Secure, session timeout).
- Test accounts (example: `testuser+ts01@pgl.co.uk / Password1!`).
- Browsers for compatibility testing (Chrome, Firefox, Safari, Edge, and a privacy-focused browser like Brave).
- Tools: browser dev tools, a cookie editor (or proxy like Fiddler/Burp), and optional automation stack (Selenium, Playwright).

Environment Configuration Checklist (coordinate with Dev/Ops)
- Cookie `Domain` set to `.pgl.co.uk` for parent-domain behavior.
- `Secure` flag enabled for cookies (HTTPS required).
- `SameSite` value configurable (None/Lax/Strict) for tests evaluating cross-site behavior.
- Session timeout configurable (able to set short TTL for expiry tests).
- Ensure test subdomains are reachable (www, holiday, services, en, fr, etc.).

General Test Execution Steps
1. Open `TestCases/Login_Session_Across_Subdomains.docx` and choose the test case(s) to run.
2. For each test case:
	 - Verify preconditions listed in the test case (account, environment config).
	 - Perform the step-by-step actions in the same browser session unless test requires separate contexts.
	 - Use browser dev tools → Application (Storage) → Cookies to inspect cookie attributes (`Domain`, `Secure`, `SameSite`, expiry).
	 - Capture screenshots of important steps (login success, cookie attributes, error responses).
	 - Capture HTTP(S) request/response headers when relevant (for cookie transmission, server errors, redirects).
3. Record pass/fail and attach artifacts (screenshots, header captures) to the test run record.

Specific Notes by Test Type
- SameSite/ITP Tests: Use an iframe or cross-origin flow to confirm cookie behavior; test with `SameSite=None` + `Secure` and with `Lax`/`Strict` to observe differences.
- Logout Propagation: Log in in one tab and validate logout in other tabs after server-side invalidation.
- Session Fixation / Cookie Reuse: Use a cookie editor or proxy to copy cookies between browsers; verify server rejects replayed sessions.
- Header/Size Limits: Use proxy tooling to craft large cookies and watch for 400/431 responses from proxies or servers.

Automation Tips
- Prefer Playwright/Selenium to automate flows that span multiple subdomains and validate cookie attributes via the browser context APIs.
- For SameSite=None tests, ensure automation runs in a fresh context that supports `Secure` cookies (HTTPS).
- Keep automation stable by using explicit waits for page load and element visibility rather than fixed sleeps.

Recording Results
- For each test case record:
	- Test Case ID, Result (Pass/Fail/Blocked), Tested By, Date/Time
	- Environment (staging url, cookie config used)
	- Artifacts: screenshots, HAR or request/response logs, cookie dumps
	- Notes/Observations and recommended remediation if failed

Troubleshooting
- If cookies are not visible on a subdomain: verify `Domain` attribute and that browser is contacting the same parent domain; check for HTTP vs HTTPS (Secure flag).
- If cross-site flows fail: validate `SameSite` value and browser privacy settings (ITP, tracker blocking).
- If behavior differs between browsers: capture detailed header logs and note browser/version.

Contacts
- QA: Your QA team (add names here)
- Dev/Ops: Coordinate with the team owning cookie/session config for toggles

If you want, I can:
- Add a one-click automated test script (Playwright) that runs the core happy path and captures cookies; or
- Add a formatted test results template (CSV) to record results consistently.
