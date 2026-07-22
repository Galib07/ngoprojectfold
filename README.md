# NgoProjectFold

**One shared PowerShell command** for three NGO departments - MEAL,
Business Development, and Project Management - that creates a
customized project folder structure through a dialog box.

Developed by **Asadullah All Galib** (galib.ihe.du.bd@gmail.com) (https://github.com/Galib07)

## The one command

```powershell
New-ProjectFolder -Path "D:\NGO\Projects"
```

That's the only command anyone needs to remember. A dialog box opens
where each person:

- picks **their own department** from a dropdown (MEAL,
  Business_Development, or Project_Management) - the folder list
  instantly switches to that department's own structure
- confirms/changes the project name, path, author, and email
- ticks/unticks any folder they don't need
- adds their own new master folder, or a new sub-folder inside any
  existing folder (old or newly added)

No department flag on the command line - the dialog handles it.

### Auto-serial numbering

Folder names are stored without numbers. Numbers (`01_`, `02_`,
`03_` ...) are added automatically when folders are created, counting
only what's ticked — so unticking one folder never leaves a gap
(e.g. ticking 4 out of 5 still gives you a clean `01-02-03-04`). This
applies at every level, including anything added by hand.

## Default folder structures

**MEAL**
```
Admin
  Project_Proposal, ToRs_and_Contracts
  Project_Design/ Concept_and_Proposal, Logframe, ToC
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
  Analysis/ Data, Output_Tables, Output_Figures,
  Beneficiary_Database, Data_Protection_and_Consent, Supplementary_Data
Reporting
  Donor_Reports, Internal_Reports, Event_Reports,
  Incident_Reports, Dashboards, Presentations
Communications_and_Visibility
  Banners_and_Posters, Media_and_Photos
```

**Business_Development**
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

**Project_Management**
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

Edit `$Script:DepartmentStructures` near the top of
`NgoProjectFold.psm1` any time to change any of these three
structures. Don't add numbers in there — the script numbers folders
automatically at creation time.

## Install and run (one line, one time)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/Galib07/ngoprojectfold/main/Install.ps1 | iex
```

This automatically:
- downloads the module into your personal PowerShell Modules folder
- sets up your PowerShell profile so it loads automatically every
  time you open PowerShell in the future
- **immediately opens the folder-setup dialog box in that same
  window** — no closing/reopening PowerShell, no second command

If PowerShell blocks the command with an execution-policy error, run
this once, then confirm with `Y`, then run the install line again:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

From the next time onward, you don't need the install line at all —
just open PowerShell and run:
```powershell
New-ProjectFolder -Path "D:\NGO\Projects"
```

### Advanced (optional): skip the dialog

```powershell
New-ProjectFolder -Path "D:\NGO\Projects" -ProjectName "ProjectX" -Department Business_Development -NoGui
```
(`-Department` accepts `MEAL`, `Business_Development`, or `Project_Management`.)

## Publishing / updating this repository (maintainer only)

1. Create a Public GitHub repository named `ngoprojectfold`.
2. Upload these five files to it: `NgoProjectFold.psm1`,
   `NgoProjectFold.psd1`, `Install.ps1`, `README.md`, `LICENSE`.
3. Share this one line with the team:
   ```
   irm https://raw.githubusercontent.com/Galib07/ngoprojectfold/main/Install.ps1 | iex
   ```
4. To update later, edit `NgoProjectFold.psm1` and re-upload it with
   the same filename (overwrite). Team members just re-run the same
   install line to get the update.

## Sensitive folders

`Safeguarding_and_PSEA`, `Beneficiary_Database`, and
`Data_Protection_and_Consent` (MEAL department) may hold personally
identifiable or highly sensitive information. The script can only
create folders, not set Windows permissions — if any of these are
created, a reminder is written into `ProjectInfo.txt` inside the
project folder to manually restrict access (right-click the folder →
Properties → Security).

## Developer

**Asadullah All Galib**
galib.ihe.du.bd@gmail.com
https://github.com/Galib07
