# 📋 How to Clone the QA-Documentation Repository in VS Code

**For:** PGL Beyond QA Test Team  
**Purpose:** Set up the QA-Documentation repository in a separate VS Code window, away from your Playwright testing files

---

## ✅ Before You Start
Make sure you have:
- [ ] **VS Code** installed
- [ ] **GitHub Copilot** access (check with Anna/your manager)
- [ ] A **GitHub account** linked to PGL-Beyond

---

## 📌 Step 1 — Find YOUR Repository URL

> ⚠️ **Important — each team member has their own repository URL!**

Your URL will be unique to your GitHub username. To find it:

1. Go to **[github.com](https://github.com)** and log in
2. Click your **profile picture** (top right)
3. Click **"Your repositories"**
4. Find and click on **"QA-Documentation"**
5. Click the green **"Code"** button
6. Copy the URL shown — it will look like:
   ```
   https://github.com/[YourGitHubUsername]/QA-Documentation
   ```

> 💡 For example:
> - Anna's URL: `https://github.com/AnnaWardQA/QA-Documentation`
> - Your URL: `https://github.com/[YourUsername]/QA-Documentation`

---

## 📌 Step 2 — Open a New VS Code Window
1. Open **VS Code**
2. Click **File** in the top menu
3. Click **New Window**

> ⚠️ Always open a new window — do NOT clone into your existing Playwright workspace!

---

## 📌 Step 3 — Open the Command Palette
1. Press **Ctrl + Shift + P** on your keyboard
2. A search bar will appear at the top of the screen
3. Type `Git Clone`
4. Click **"Git: Clone"** from the dropdown

---

## 📌 Step 4 — Enter YOUR Repository URL
1. When prompted, paste in **your own URL** copied from Step 1:
   ```
   https://github.com/[YourGitHubUsername]/QA-Documentation
   ```
2. You will see two options appear — click:
   > **"Clone from URL"**

---

## 📌 Step 5 — Choose Where to Save It
1. A folder picker window will open
2. Navigate to your **source\repos** folder:
   ```
   C:\Users\[YourName]\source\repos
   ```
3. Click **"Select as Repository Destination"**

> 💡 If you don't have a `source\repos` folder, you can save it in **Documents** instead

---

## 📌 Step 6 — Open in a New Window
1. When the clone finishes, VS Code will ask:
   > *"Would you like to open the repository?"*
2. Click **"Open in New Window"**

---

## 📌 Step 7 — Trust the Folder
1. A yellow banner may appear at the top saying **"Restricted Mode"**
2. Click **"Manage"**
3. Click **"Trust"** or confirm you trust the folder
4. You should see: ✅ *"You trust this folder — All features are enabled"*

---

## ✅ You're All Set!
Your explorer panel on the left should show these folders:

```
📁 QA-DOCUMENTATION
   📁 .github
   📁 Defects
   📁 Processes
   📁 RegressionPacks
   📁 ReleaseNotes
   📁 Requirements
   📁 TestCases
   📁 TestPlans
   📁 UAT-Test-Packs
   📄 README.md
```

---

## 🔄 Keeping Your Repository Up to Date

It is important to regularly **sync your local repository with the main branch** to ensure you always have the latest documents and updates made by your teammates.

Before starting any new work, always refresh your local copy by clicking the **sync icon** (🔄) next to **"main"** in the bottom left of VS Code.

> ⚠️ If you do not sync regularly, your local copy may become **out of date**, meaning you could be working from old documents or miss updates that colleagues have already made.

**A good habit is:**
- Sync **at the start of every working day**
- Sync **before creating any new documents**
- Sync **after a colleague tells you they have added something new**

---

## 💬 Using Copilot Chat to Create Documents

Once set up, open the **Copilot Chat panel** (right side of VS Code) and try:

> *"Using the Azure DevOps MCP, fetch PBI [number] from pgltravel and save a Test Plan document in the TestPlans folder"*

### 📋 What to Expect
1. Copilot may ask some **clarifying questions** before it proceeds — answer these as accurately as possible
2. When prompted, provide the **full Azure DevOps URL** for the PBI, for example:
   ```
   https://dev.azure.com/PGL-Beyond/pgltravel/_workitems/edit/[PBINumber]
   ```
3. Copilot will **fetch the PBI details** from Azure DevOps, including the title, description and acceptance criteria
4. It will then **automatically generate** a Test Plan document based on the PBI content
5. The document will be **saved directly** into the correct folder (e.g. TestPlans) in your repository — no manual saving required!

> 💡 You do not need to create anything in Azure DevOps — Copilot only reads from it and saves the document locally to your repository

---

## 👁️ Viewing Documents in a User-Friendly Format

Documents are saved as Markdown (`.md`) files. Here are the best ways to view them:

**Option 1 — View on GitHub Website** ✅ Recommended
1. Go to `https://github.com/[YourUsername]/QA-Documentation`
2. Navigate to the relevant folder (e.g. **TestPlans**)
3. Click the file — GitHub automatically displays it in a clean, formatted view

**Option 2 — Preview in VS Code**
1. Open the file in VS Code
2. Press **Ctrl + Shift + V** to open a formatted preview
3. Or click the **preview icon** (split screen icon) in the top right corner of the file

**Option 3 — Copy into Word**
1. Open the file and copy the contents (**Ctrl + A**, then **Ctrl + C**)
2. Paste into a **Microsoft Word** document (**Ctrl + V**)
3. Save and upload to SharePoint if needed

---

## ❓ Need Help?
Contact **Anna Ward (AnnaWardQA)** or raise a question in the team channel.
