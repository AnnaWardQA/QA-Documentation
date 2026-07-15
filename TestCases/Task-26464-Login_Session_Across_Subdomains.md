# Test Cases — Task 26464 (ADHD-friendly layout)

Quick purpose
- Make login sessions carry across all subdomains (share cookies across domains).

Files
- Full test cases: `TestCases/Login_Session_Across_Subdomains.docx`
- Copy-friendly version: `TestCases/Task-26464-Login_Session_Across_Subdomains.md` (this file)

Quick TL;DR (two lines)
- Log in on main domain → visit subdomain → you should stay logged in.
- Focus on cookie attributes: `Domain`, `Secure`, `SameSite`, expiry.

Quick-start checklist (use this as a running to-do)
- [ ] Have a test account ready (e.g., testuser+ts01@pgl.co.uk / Password1!)
- [ ] Use a fresh browser profile or Incognito/Private window
- [ ] Confirm staging has subdomains reachable (www, holiday, services, en, fr)
- [ ] Confirm Dev/Ops can toggle cookie settings if needed (`Domain`, `SameSite`, `Secure`, timeout)

How I organized this file
- Quick Run Cards: 12 one-line cards for fast scanning
- Detailed steps: full step-by-step instructions below each card
- Tips: short ADHD-friendly test tips and timers

---

## Quick Run Cards (one-line summaries — pick one and run it)

1. TS-001 — Basic cross-subdomain login persistence — Log in on `www` → open `holiday` → expect still logged in. (High)
2. TS-002 — Post-login redirect — Log in on `www` that redirects to `services` → expect logged in. (High)
3. TS-003 — Secure cookie & HTTP vs HTTPS — Log in over HTTPS, visit HTTP subdomain → expect not logged in on HTTP. (High)
4. TS-004 — Cookie Domain attribute — Ensure cookie `Domain=.pgl.co.uk` so all subdomains receive it. (High)
5. TS-005 — SameSite None/Lax/Strict — Test iframe/cross-site flows with different SameSite values. (High)
6. TS-006 — Logout propagation — Log out on one subdomain → confirm other tabs/subdomains are logged out. (High)
7. TS-007 — Session expiry boundary — Short TTL test: wait expiry → confirm re-login required. (Medium)
8. TS-008 — Session fixation / cookie reuse — Copy cookie to another browser → server should reject. (Medium)
9. TS-009 — Cookie header size limits — Generate large cookie → observe truncation/errors. (Low)
10. TS-010 — Subdomain permutations — Test `en.`, `fr.`, `holiday.`, `services.` variants. (Medium)
11. TS-011 — Different ports — Test same host on alternate port (if available). (Low)
12. TS-012 — ITP / privacy browsers — Test in Safari/Brave/Firefox strict. (Medium)

---

## ADHD-friendly testing tips
- Set a 25-minute timer for one or two test cards (Pomodoro).
- Use checkboxes in this file to track progress.
- Keep artifacts (screenshots/HARs) named with `TS-###_YYYYMMDD.png`.
- If a test needs env changes, block that test and move to the next.

---

## Detailed Test Cases (expanded)

> Tip: Run the Quick Run Card first, then follow the detailed steps below for evidence capture.

### TS-001 — Basic cross-subdomain login persistence (Happy path)
Description: After logging in on the main domain, the user remains authenticated when navigating to other subdomains.

Preconditions:
- Test account ready
- Fresh browser (no cookies)
- HTTPS available
- Cookie `Domain` set to `.pgl.co.uk` (staging)

Steps:
1. Open fresh browser session.
2. Go to `https://www.pgl.co.uk/login` and sign in.
3. Confirm profile/user name visible on `www`.
4. Navigate to `https://holiday.pgl.co.uk` in same session.
5. Confirm profile visible (no login prompt).
6. DevTools → Application → Cookies: confirm session cookie `Domain=.pgl.co.uk`.

Expected result: User stays logged in; cookie domain is parent domain.

Time estimate: 2–4 minutes

---

### TS-002 — Login then redirect to subdomain
Description: Post-auth redirect retains session.

Preconditions: Redirect configured; same as TS-001.

Steps:
1. Fresh browser → login on `www`.
2. Trigger redirect to `https://services.pgl.co.uk/dashboard`.
3. Confirm dashboard shows user data (no login).
4. Check cookie `Domain=.pgl.co.uk`.

Expected: Redirect lands authenticated.

Time: 2–4 minutes

---

### TS-003 — Cookie Secure flag and HTTP vs HTTPS
Description: `Secure` cookies not sent over HTTP.

Preconditions: Secure cookies configured; HTTP/HTTPS endpoints available.

Steps:
1. Login over HTTPS on `www`.
2. Confirm authenticated on `https://holiday.pgl.co.uk`.
3. Visit `http://holiday.pgl.co.uk` and check authentication.
4. Inspect cookies in both contexts.

Expected: Not authenticated on HTTP; cookie only sent on HTTPS.

Time: 3–5 minutes

---

### TS-004 — Cookie Domain attribute correctness
Description: `Domain=.pgl.co.uk` vs `Domain=www.pgl.co.uk` behavior.

Preconditions: Ability to change cookie Domain in staging.

Steps:
1. Set cookie Domain to `.pgl.co.uk` (or ask Dev/Ops).
2. Login and verify cookie attribute.
3. Visit several subdomains and confirm auth.
4. Switch cookie to `www.pgl.co.uk` and confirm other subdomains lose auth.

Expected: Parent-domain cookie visible to all subdomains.

Time: 10–20 minutes (if env change needed)

---

### TS-005 — SameSite attribute: None vs Lax vs Strict
Description: Validate cookie behavior for cross-site flows (iframes, cross-origin redirects) with SameSite set to `None`, `Lax`, and `Strict`.

Preconditions:
- Ability to change SameSite setting in staging
- Test page or iframe host on different origin for cross-site context

Steps:
1. Set cookie SameSite=None and Secure=true (ask Dev/Ops if needed).
2. Login on `www` and load the subdomain inside an iframe hosted on a different origin (or perform a cross-site redirect).
3. Confirm session is available inside iframe/cross-site request.
4. Change SameSite to Lax, repeat; note whether cookie is sent in the cross-site scenario.
5. Change SameSite to Strict, repeat; note behavior.

Expected: SameSite=None+Secure allows cross-site contexts; Lax/Strict block some cross-site cookie uses per spec.

Time: 10–25 minutes (depends on iframe setup)

---

### TS-006 — Logout propagation across subdomains
Description: Ensure logging out on one subdomain invalidates the session on other subdomains/tabs.

Preconditions:
- User logged in and authenticated across at least two subdomains

Steps:
1. Login on `www`.
2. Open `https://holiday.pgl.co.uk` in a second tab and confirm authenticated.
3. On `www`, click Logout (or call logout endpoint).
4. On the holiday tab, refresh protected page(s) and confirm user is logged out or redirected to login.
5. Check server-side session state if accessible (optional).

Expected: Logout invalidates session across all subdomains.

Time: 3–7 minutes

---

### TS-007 — Session expiry and cookie expiry boundary
Description: Confirm behavior when session TTL expires and cookie expiry boundaries align with server session state.

Preconditions:
- Session timeout configurable (or short TTL available for test)

Steps:
1. Login and confirm authenticated across subdomains.
2. Wait for configured session timeout + small buffer.
3. Attempt to access a protected resource on a subdomain.
4. Confirm application forces re-authentication (login prompt) and cookie is expired/unaccepted.

Expected: After expiry, session is invalidated and protected pages require login on all subdomains.

Time: depends on TTL (recommended: 1–15 minutes)

---

### TS-008 — Concurrent sessions and session fixation (cookie reuse)
Description: Verify server resists cookie replay/fixation attempts across different client contexts.

Preconditions:
- Two browser contexts available (different machines or incognito window)
- Tool to read/set cookies (browser devtools, cookie editor, proxy)

Steps:
1. Login in Browser A; capture session cookie value.
2. In Browser B, set the captured cookie value for the parent domain.
3. Attempt to access protected resources in Browser B.
4. Observe whether server accepts the cookie or denies/forces re-login.
5. Optionally, attempt actions requiring elevated privileges to detect partial acceptance.

Expected: Server rejects replayed cookies or prompts re-authentication; no silent takeover.

Time: 10–20 minutes

---

### TS-009 — Cookie header size and server/proxy limits
Description: Test behavior when cookie header sizes approach or exceed typical HTTP limits (causing truncation or errors).

Preconditions:
- Ability to create large cookie payloads (dev or proxy)
- Awareness of upstream proxy/server header limits

Steps:
1. Using a dev/test hook or proxy, create a large cookie payload near expected limits.
2. Login or inject cookie and make requests to subdomains.
3. Monitor responses for truncation, `400`/`431` errors, or authentication failures.
4. Capture request/response headers (HAR) for evidence.

Expected: If headers exceed limits, requests fail or cookies get truncated leading to auth failures; document exact failure modes.

Time: 15–30 minutes

---

### TS-010 — Subdomain permutations: regional and service variants
Description: Validate session across multiple realistic subdomain permutations (locale/service variants).

Preconditions:
- Subdomains reachable: `en.pgl.co.uk`, `fr.pgl.co.uk`, `holiday.pgl.co.uk`, `services.pgl.co.uk`, etc.

Steps:
1. Login on primary domain (`www`).
2. Visit each subdomain variant in the same session and confirm authenticated state.
3. Attempt to access protected resources on each subdomain and confirm behavior.

Expected: Authentication persists across all subdomains covered by the cookie domain; note any subdomains outside scope.

Time: 5–15 minutes

---

### TS-011 — Different ports on same host
Description: Confirm cookie transmission and auth behavior when the same host is accessed on non-standard ports.

Preconditions: Test services running on alternate ports (e.g., :8443)

Steps:
1. Login on `https://www.pgl.co.uk` (default port 443).
2. Access the same hostname on alternate port (e.g., `https://www.pgl.co.uk:8443`) in same session.
3. Observe whether cookie is sent and whether user remains authenticated.

Expected: Cookies are host/scheme based and typically sent regardless of port; verify infrastructure-specific behavior.

Time: 5–15 minutes

---

### TS-012 — ITP / browser privacy features and third-party cookie blocking
Description: Test behavior in browsers with Intelligent Tracking Prevention or strict privacy settings that may block cookies in cross-site contexts.

Preconditions: Browsers with strict privacy modes available (Safari, Brave, Firefox strict)

Steps:
1. In a privacy-focused browser, login on primary domain.
2. Perform cross-site or iframe flows that require cookie sharing.
3. Observe whether cookies are blocked and whether the app falls back or prompts for re-authentication.
4. Document differences vs Chrome/Edge.

Expected: Some browsers will block cookies in certain contexts; document exact behavior and recommended mitigations (SameSite=None+Secure, token-based fallbacks).

Time: 10–30 minutes

---

#### Notes & test data references
- Use dedicated test accounts (e.g., `testuser+ts01@pgl.co.uk / Password1!`).
- Capture artifacts: screenshots, HARs, cookie dumps, server logs when possible.
- Coordinate env toggles with Dev/Ops for cookie `Domain`, `SameSite`, `Secure`, and TTL changes.
- Name artifacts consistently: `TS-###_YYYYMMDD_HHMMSS.ext`.




