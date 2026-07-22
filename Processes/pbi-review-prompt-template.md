# PBI Test Case Prompt — Quick Start Template

Copy the prompt below into GitHub Copilot Chat in VS Code.
Replace the two values in **bold** and send. Copilot will do the rest.

---

## The Prompt

```
Review PBI **[PBI_URL]**

Include all linked artefacts (Tasks, Pull Requests, Test Suites etc).

Once you understand the scope of the item, draft a Test Plan with individual Test Cases covering:
- positive/happy path scenarios
- negative scenarios
- boundary and edge cases
- validation scenarios
- accessibility (keyboard, screen reader, contrast)
- security scenarios where applicable

For each test case provide:
- title (format: TC-NN - Short description)
- preconditions
- executable step-by-step actions with specific URLs and test data (no placeholders)
- expected results

Save the output as `TestCases/pbi-[PBI_NUMBER]-testcases.json` in this exact format:

[
  {
    "title": "TC-01 - Example title",
    "steps": "<steps id=\"0\" last=\"2\"><step id=\"1\" type=\"ValidateStep\"><parameterizedString isformatted=\"true\">Action here.</parameterizedString><parameterizedString isformatted=\"true\">Expected result here.</parameterizedString><description/></step></steps>"
  }
]

Once the file is saved, update Scripts/import-testcases.py with:
  PLAN_ID and SUITE_ID from this Test Suite URL: **[TEST_SUITE_URL]**

Then run:
  python Scripts/import-testcases.py

Confirm how many test cases were created and their ADO work item IDs.
```

---

## What to replace

| Placeholder | What to put here | Example |
|-------------|-----------------|---------|
| `[PBI_URL]` | Full URL to the PBI in Azure DevOps | `https://pgltravel.visualstudio.com/Apps/_workitems/edit/26041` |
| `[TEST_SUITE_URL]` | Full URL to the Test Suite in ADO Test Plans | `https://pgltravel.visualstudio.com/Apps/_testPlans/define?planId=8202&suiteId=26043` |

---

## Before you start — check these once per session

- [ ] Azure CLI is logged in: `az login`
- [ ] Defaults are set: `az devops configure --defaults organization=https://pgltravel.visualstudio.com project=Apps`

> See `Processes/pbi-review-prompt.md` for the full reference guide and troubleshooting.
