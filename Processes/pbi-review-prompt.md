# PBI Review & Test Case Generation — End-to-End Process

This document describes the complete, repeatable process for reviewing a PBI, generating test cases, and automatically importing them into an Azure DevOps Test Suite.

---

## Prerequisites (one-time setup)

These steps only need to be done once per machine.

1. **Install Azure CLI**
   Download from https://aka.ms/installazurecliwindows and install.

2. **Install the Azure DevOps extension**
   ```powershell
   az extension add --name azure-devops
   ```

3. **Log in**
   ```powershell
   az login
   ```
   A browser window will open — sign in with your `anna.ward@pglbeyond.com` account.

4. **Set ADO defaults**
   ```powershell
   az devops configure --defaults organization=https://pgltravel.visualstudio.com project=Apps
   ```

---

## Step 1 — Review the PBI and generate test cases

Use the following prompt with GitHub Copilot (in VS Code or copilot.github.com):

````
Review PBI [PBI_NUMBER]
Product Backlog Item [PBI_NUMBER] [PBI_TITLE]
Azure DevOps project: https://pgltravel.visualstudio.com/Apps
Include all linked artefacts (Tasks, Pull Requests, Test Suites etc).

Once you understand the scope of the item, draft a Test Plan including individual Test Cases covering:
- positive/happy path scenarios
- negative scenarios
- boundary and edge cases
- validation scenarios
- accessibility scenarios (keyboard, screen reader, contrast)
- security scenarios where applicable

For each test case provide:
- title (format: TC-NN - Short description)
- preconditions
- executable step-by-step actions with specific test URLs/data
- expected results
- any required test data (use repeatable real values, not placeholders)

Save the output as `TestCases/pbi-[PBI_NUMBER]-testcases.json` using this exact format:

```json
[
  {
    "title": "TC-01 - Example test case title",
    "steps": "<steps id=\"0\" last=\"2\"><step id=\"1\" type=\"ValidateStep\"><parameterizedString isformatted=\"true\">Action step here.</parameterizedString><parameterizedString isformatted=\"true\">Expected result here.</parameterizedString><description/></step></steps>"
  }
]
```
````

> **Important:** The `steps` field must be valid ADO XML. Each `<step>` contains two `<parameterizedString>` elements: the first is the action, the second is the expected result.

---

## Step 2 — Import test cases into Azure DevOps

Once the JSON file has been saved to `TestCases/pbi-[PBI_NUMBER]-testcases.json`, run the import script:

```powershell
python Scripts/import-testcases.py
```

The script will:
1. Read the JSON file
2. Create each test case as a Work Item in ADO (type: Test Case)
3. Automatically add each test case to the specified Test Suite

> The script is located at `Scripts/import-testcases.py`. Before running for a new PBI, update the following variables at the top of the script:
>
> ```python
> PLAN_ID = 8202       # Test Plan ID from ADO URL (planId=XXXX)
> SUITE_ID = 26043     # Test Suite ID from ADO URL (suiteId=XXXX)
> ```
>
> You can find these in the ADO Test Plans URL:
> `https://pgltravel.visualstudio.com/Apps/_testPlans/define?planId=XXXX&suiteId=XXXX`

---

## Step 3 — Verify in ADO

1. Go to your Test Plan in ADO
2. Open the relevant Test Suite
3. Confirm all test cases appear with their steps correctly populated

---

## Example (PBI 26041 — PGL front page menu changes)

| Field | Value |
|-------|-------|
| PBI | 26041 |
| Test Plan ID | 8202 |
| Test Suite ID | 26043 |
| JSON file | `TestCases/pbi-26041-testcases.json` |
| Work items created | #26775 – #26787 |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `FileNotFoundError` when running script | Use `az.cmd` not `az` — already handled in the script |
| `--organization must be specified` | Run `az devops configure --defaults organization=https://pgltravel.visualstudio.com project=Apps` |
| `Auto-detect was enabled` warning | Safe to ignore — this is because the repo remote is GitHub, not ADO |
| Test cases created but not in suite | Check `PLAN_ID` and `SUITE_ID` values in the script match the ADO URL |
| Duplicate test cases in suite | Do not run the script twice — each run creates new work items |
| `az login` expired | Run `az login` again to refresh your session |
