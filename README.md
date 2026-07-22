# 📂 NgoProjectFold

**One simple command creates all your project folders automatically** - built for three NGO teams: **MEAL**, **Business Development**, and **Project Management**.

👨‍💻 Developed by **[Asadullah All Galib](https://github.com/Galib07)** - galib.ihe.du.bd@gmail.com

---

## ✨ What does this do?

Instead of manually creating dozens of folders (Admin, Budget, Reports, etc.) every time you start a new project, you run **one command**. A small window pops up, you:

1. 🏢 Pick your **department** (MEAL / Business Development / Project Management)
2. ✅ Tick the folders you want (or leave everything ticked)
3. 📁 Click **Create Folders**

...and your entire project folder structure is built in one second - correctly numbered, every time. No technical knowledge needed.

---

## 🚀 Start & Installation (one time only)

Open **PowerShell** on your PC, copy and paste the following command, then press Enter

```powershell
irm https://raw.githubusercontent.com/Galib07/ngoprojectfold/main/Install.ps1 | iex
```

That's it. The setup window opens automatically - no extra steps.

> ⚠️ If you see a red "execution policy" error instead, paste this once, press **Y**, then run the line above again:
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

**From then on**, you never need that install line again - just open PowerShell and type:

```powershell
New-ProjectFolder -Path "D:\NGO\Projects"
```

---

## 🧭 How it works

| Step | What you see | What you do |
|---|---|---|
| 1️⃣ | A dropdown labeled **Department** | Choose MEAL, Business_Development, or Project_Management |
| 2️⃣ | Project name & folder location boxes | Type a name, click **Browse...** to pick where |
| 3️⃣ | A list of folders, all ticked by default | Untick anything you don't need |
| 4️⃣ | "+ New Master Folder" / "+ New Sub-folder" buttons | Add your own folders if something's missing |
| 5️⃣ | **Create Folders** button | Click it - done! |

---

## 🔢 Automatic numbering - no gaps, ever

You never have to think about numbers. Folders are just named things like `Budget` or `Monitoring_Reports` behind the scenes - when you click **Create Folders**, they're automatically numbered `01_`, `02_`, `03_`... based on what's ticked.

So if you untick folder #3 out of 5, you still get a clean `01, 02, 03, 04` - never a gap like `01, 02, 04, 05`. This works for sub-folders too, and for anything you add yourself.

---

## 🗂️ What folders does each department get?

<details>
<summary><strong>🟢 MEAL</strong> (click to expand)</summary>

```
Admin
  Project_Proposal, ToRs_and_Contracts
  Project_Design → Concept_and_Proposal, Logframe, ToC
  DIP_and_Gantt_Chart, Workplan, Budget, Ethics_and_IRB,
  Procurement_Requests, Meeting_Minutes, Correspondence
Monitoring
  Indicators_and_Tools, MEAL_Framework_and_Plan, SoPs,
  Monitoring_Checklist, Monitoring_Reports, Project_Tracking
Evaluation
  Baseline, Midline, Endline, ToRs_and_Proposals, Evaluation_Reports
Accountability
  Policy_and_Regulations, Feedback_and_Complaints,
  Community_Consultations, Safeguarding_and_PSEA
Learning
  Lessons_Learned, Case_Studies, Knowledge_Products,
  Learning_Events, Beneficiary_Feedback
Data_Management
  Tools_and_Forms, Raw_Data, Clean_Data, Code_and_Syntax,
  Analysis → Data, Output_Tables, Output_Figures,
  Beneficiary_Database, Data_Protection_and_Consent, Supplementary_Data
Reporting
  Donor_Reports, Internal_Reports, Event_Reports,
  Incident_Reports, Dashboards, Presentations
Communications_and_Visibility
  Banners_and_Posters, Media_and_Photos
```
</details>

<details>
<summary><strong>🔵 Business Development</strong> (click to expand)</summary>

```
Admin
  Team_ToRs_and_Job_Descriptions, Meeting_Minutes, Correspondence
Donor_Intelligence
  Donor_Profiles, Funding_Opportunities, Donor_Mapping
Proposal_Development
  Concept_Notes, Full_Proposals, Budgets, Logframe_and_ToC, Annexes
Partnerships
  MOUs_and_Agreements, Partner_Profiles, Consortium_Documents
Research_and_Business_Intelligence
  Market_Analysis, Needs_Assessments, Competitor_Analysis
Compliance_and_Due_Diligence
  Donor_Compliance_Checklists, Organizational_Capacity_Statements,
  Registration_and_Legal_Documents
Communications_and_Branding
  Case_for_Support, Pitch_Decks, Success_Stories
Reporting
  Pipeline_Tracker, Win_Loss_Analysis, Internal_BD_Reports
```
</details>

<details>
<summary><strong>🟠 Project Management</strong> (click to expand)</summary>

```
Admin
  Project_Charter, ToRs_and_Contracts, Meeting_Minutes, Correspondence
Planning
  Workplan_and_Gantt_Chart, Logframe_and_ToC, Risk_Register, Procurement_Plan
Budget_and_Finance
  Budget_and_Forecast, Expenditure_Tracking, Financial_Reports
Implementation
  Activity_Reports, Field_Visit_Reports, Deliverables
HR_and_Team
  Staffing_Plan, Onboarding_Documents, Team_Contact_List
Procurement_and_Logistics
  Purchase_Requests, Vendor_Contracts, Asset_Inventory
Reporting
  Donor_Reports, Internal_Reports, Dashboards
Risk_and_Issue_Management
  Risk_Log, Issue_Log, Lessons_Learned
Closeout
  Handover_Documents, Final_Report, Asset_Disposal
```
</details>

💡 Want to change any of these? Edit `$Script:DepartmentStructures` near the top of `NgoProjectFold.psm1`. No numbers needed there - the tool numbers everything automatically.

---

## 🗃️ Versions

#### 📌 Current version

📝 **v1.0.0** - July 2026 [View this version](https://github.com/Galib07/ngoprojectfold/releases/tag/ProjectManagement)

---

## 🛠️ Advanced usage (optional - most people can skip this)

Skip the dialog box entirely and create the full default structure right away:

```powershell
New-ProjectFolder -Path "D:\NGO\Projects" -ProjectName "ProjectX" -Department Business_Development -NoGui
```

`-Department` accepts `MEAL`, `Business_Development`, or `Project_Management`.

---

## 🔒 A note on sensitive folders

A few MEAL folders - `Safeguarding_and_PSEA`, `Beneficiary_Database`, `Data_Protection_and_Consent` - may hold personal or sensitive information. This tool can create folders, but it **cannot** set Windows permissions. If any of these are created, you'll see a reminder inside `ProjectInfo.txt` to manually restrict access:
right-click the folder → **Properties** → **Security**.

---

## 👤 Developer

**Asadullah All Galib**
📧 galib.ihe.du.bd@gmail.com
🔗 [github.com/Galib07](https://github.com/Galib07)
