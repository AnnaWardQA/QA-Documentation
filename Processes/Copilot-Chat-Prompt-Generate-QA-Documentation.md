# 💬 Copilot Chat Prompt — Generate QA Documentation from Azure DevOps PBI

## How to Use

1. Open **Copilot Chat** in your QA-Documentation VS Code window
2. Paste the prompt below into the chat
3. Replace `<Insert Azure DevOps URL here>` with the full URL of your PBI
4. Hit send!

---

## The Prompt

```
You are a QA Software Test Analyst.

Using the Azure DevOps MCP, review the following work item including any file 
attachments, links, discussion notes and acceptance criteria:

<Insert Azure DevOps URL here>

Generate a complete set of QA documentation and save each document into the 
correct folder in this repository using existing naming conventions:

- TestPlans — full Test Plan document
- TestCases — detailed Test Cases
- UAT-Test-Packs — UAT Pack
- ReleaseNotes — Release Notes

Each document should include relevant sections from the following:

- Requirements Analysis
- Test Approach
- Test Coverage Matrix
- Test Scenarios
- Detailed Test Cases with numbered steps
- Negative Testing
- Accessibility Testing
- Regression Impact Analysis
- Risks, Gaps and Recommendations
- Execution Checklist

Use ADHD-friendly formatting throughout:
- No tables
- Clear headings
- Bullet points
- Numbered test steps
- Concise wording
- Plenty of whitespace

Ensure all acceptance criteria are covered and clearly flag any missing or 
ambiguous requirements.
```

---

## Example Azure DevOps URL Format

```
https://dev.azure.com/PGL-Beyond/pgltravel/_workitems/edit/[PBINumber]
```

> 💡 Replace `[PBINumber]` with the actual PBI number you are working on
