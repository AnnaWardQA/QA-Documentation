# 🔑 Azure DevOps MCP — PAT Token Setup

## Status
⚠️ **Action Required** — A new Personal Access Token (PAT) needs to be created to allow GitHub Copilot in VS Code to access Azure DevOps Work Items via the MCP server.

---

## Background
The Azure DevOps MCP server is configured and running in VS Code, but is currently unable to authenticate with Azure DevOps because:

- The existing PAT token only has **Code (Read & Write) and Packaging (Read)** permissions
- The MCP server needs access to **Work Items** to allow Copilot to read PBIs
- A new token with **Full Access** is required

---

## Action Required

### Check with Line Manager / IT / DevOps Team
Before creating a new token, confirm you are permitted to do so under PGL Beyond's IT and security policies.

Ask:
> *"Am I able to create a new Personal Access Token in Azure DevOps with Full Access scope for use with GitHub Copilot MCP in VS Code?"*

---

## Once Approved — How to Create the Token

1. Go to **[pgltravel.visualstudio.com/_usersSettings/tokens](https://pgltravel.visualstudio.com/_usersSettings/tokens)**
2. Click **"+ New Token"**
3. Fill in:
   - **Name:** `VS Code Copilot MCP`
   - **Organisation:** PGLTravel
   - **Expiration:** 90 days (or as long as permitted)
   - **Scopes:** Full Access
4. Click **Create**
5. ⚠️ Copy the token immediately — it cannot be viewed again after closing!

---

## Once You Have the Token — Update mcp.json

1. Press **Ctrl + Shift + P** in VS Code
2. Type **MCP** and click **"MCP: Open Configuration"**
3. Update the `mcp.json` file to:

```json
{
  "servers": {
    "microsoft/azure-devops-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp@latest"
      ],
      "env": {
        "AZURE_DEVOPS_ORG": "pgltravel",
        "AZURE_DEVOPS_PAT": "your-pat-token-here"
      }
    }
  }
}
```

4. Replace `"your-pat-token-here"` with the token you copied
5. Save the file
6. Press **Ctrl + Shift + P** → **MCP: Restart Server** → select **microsoft/azure-devops-mcp**
7. Test by running the Copilot Chat prompt with a PBI URL

---

## Notes
- Keep your PAT token safe and do not share it
- Make a note of the expiry date and set a reminder to renew it before it expires
- If the token expires, repeat the steps above to create a new one and update `mcp.json`
