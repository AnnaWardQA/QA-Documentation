# PBI Review & Test Case Generation Prompt

Use this prompt with GitHub Copilot (or any AI assistant) to review a PBI, generate a test plan, and automatically import test cases into Azure DevOps.

---

## Prompt Template

```
Review PBI [PBI_NUMBER]
Product Backlog Item [PBI_NUMBER] [PBI_TITLE]
Azure DevOps, include all linked artefacts (Tasks, Pull Requests, Test Suites etc)
Once you understand the scope of the item, draft a Test Plan including individual drafted Test Cases to cover the PBI including positive, negative, boundary, validation, and security scenarios where applicable.
For each draft test case, provide:
- title
- preconditions
- executable step-by-step actions
- expected results
- any required test data
Use repeatable data rather than placeholders.
Save the final review and draft cases in TestCases.
When complete, automatically import the test cases into Azure DevOps using the following command:

.\scripts\azure_create_testcases_from_json.ps1 -PbiId [PBI_NUMBER] -SuiteId [SUITE_ID] -PlanId [PLAN_ID]
```

---

## Example (PBI 26041)

```
Review PBI 26041
Product Backlog Item 26041 PGL front page menu changes
Azure DevOps, include all linked artefacts (Tasks, Pull Requests, Test Suites etc)
Once you understand the scope of the item, draft a Test Plan including individual drafted Test Cases to cover the PBI including positive, negative, boundary, validation, and security scenarios where applicable.
For each draft test case, provide:
- title
- preconditions
- executable step-by-step actions
- expected results
- any required test data
Use repeatable data rather than placeholders.
Save the final review and draft cases in TestCases.
When complete, automatically import the test cases into Azure DevOps using the following command:

.\scripts\azure_create_testcases_from_json.ps1 -PbiId 26041 -SuiteId 26043 -PlanId 8202
```

---

## How the Import Works

1. The script automatically obtains an Azure AD token via Azure CLI (no manual token needed)
2. It locates the JSON file at `TestCases/pbi-[PBI_NUMBER]-testcases.json`
3. It creates each test case as a work item in Azure DevOps
4. It adds each test case to the specified Test Suite
5. A CSV summary is saved to `TestCases/pbi-[PBI_NUMBER]-created-testcases.csv`

### Prerequisites
- Azure CLI installed and signed in (`az login`)
- JSON test cases file saved to `TestCases/pbi-[PBI_NUMBER]-testcases.json`
- Access to the Azure DevOps organisation `https://pgltravel.visualstudio.com`
