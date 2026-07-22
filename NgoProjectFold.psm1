#Requires -Version 5.1
<#
    NgoProjectFold.psm1
    ==================================================================
    NgoProjectFold - one shared PowerShell command for three
    departments: MEAL, Business_Development, and Project_Management.

    Developed by : Asadullah All Galib
    Contact      : galib.ihe.du.bd@gmail.com
    Repository   : https://github.com/Galib07/ngoprojectfold
    ==================================================================

    THE ONE COMMAND
    ------------------------------------------------------------------
        New-ProjectFolder -Path "D:\Projects"

    That's it - just one command, always the same, for every
    department. A dialog box opens where each person picks THEIR OWN
    department (MEAL / Business_Development / Project_Management)
    from a dropdown, and the folder list instantly switches to match.
    Nobody needs to remember a department flag on the command line.

    Inside the dialog, a person can also:
        - confirm/change the project name, destination path, author
          and email
        - tick/untick any folder they don't need
        - add a brand-new master (top-level) folder
        - add a new sub-folder inside any existing folder (old or
          newly added)

    AUTOMATIC SERIAL NUMBERING
    ------------------------------------------------------------------
    Folder names are stored below WITHOUT numbers. Numbers (01_, 02_,
    03_ ...) are generated automatically, at creation time, counting
    only the folders that are actually ticked - so unticking one
    folder never leaves a numbering gap. This applies at every level
    (master folders and sub-folders), including anything added by
    hand through the dialog.

    ADVANCED / SCRIPTED USE (optional - most people never need this)
    ------------------------------------------------------------------
        New-ProjectFolder -Path "D:\Projects" -ProjectName "ProjectX" `
            -Department Business_Development -NoGui

    Skips the dialog entirely and creates the full default structure
    for the given department right away.

    A NOTE ON SENSITIVE FOLDERS
    ------------------------------------------------------------------
    A few MEAL folders (Safeguarding_and_PSEA, Beneficiary_Database,
    Data_Protection_and_Consent) are likely to hold personally
    identifiable or otherwise sensitive information. This script can
    only create folders - it cannot set Windows permissions. When any
    of these are created, a reminder is written into ProjectInfo.txt
    to manually restrict access (right-click the folder -> Properties
    -> Security).
    ==================================================================
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic

#region ---------------------------------------------------------------
#  1. DEPARTMENT FOLDER STRUCTURES
#
#  Each department is a nested, ORDERED hashtable:
#     "FolderName" = $null                 -> a plain folder, no children
#     "FolderName" = [ordered]@{ ... }     -> a folder with sub-folders
#  Nesting can go as deep as you like. Do NOT add numbers here - see
#  "AUTOMATIC SERIAL NUMBERING" above. Edit freely; every change here
#  is reflected in the dialog automatically.
#-------------------------------------------------------------------
#endregion

$Script:DepartmentStructures = [ordered]@{

    "MEAL" = [ordered]@{
        "Admin" = [ordered]@{
            "Project_Proposal"     = $null
            "ToRs_and_Contracts"   = $null
            "Project_Design"       = [ordered]@{
                "Concept_and_Proposal" = $null
                "Logframe"             = $null
                "ToC"                  = $null
            }
            "DIP_and_Gantt_Chart"  = $null
            "Workplan"             = $null
            "Budget"               = $null
            "Ethics_and_IRB"       = $null
            "Procurement_Requests" = $null
            "Meeting_Minutes"      = $null
            "Correspondence"       = $null
        }
        "Monitoring" = [ordered]@{
            "Indicators_and_Tools"    = $null
            "MEAL_Framework_and_Plan" = $null
            "SoPs"                    = $null
            "Monitoring_Checklist"    = $null
            "Monitoring_Reports"      = $null
            "Project_Tracking"        = $null
        }
        "Evaluation" = [ordered]@{
            "Baseline"           = $null
            "Midline"            = $null
            "Endline"            = $null
            "ToRs_and_Proposals" = $null
            "Evaluation_Reports" = $null
        }
        "Accountability" = [ordered]@{
            "Policy_and_Regulations"   = $null
            "Feedback_and_Complaints"  = $null
            "Community_Consultations" = $null
            "Safeguarding_and_PSEA"    = $null
        }
        "Learning" = [ordered]@{
            "Lessons_Learned"      = $null
            "Case_Studies"         = $null
            "Knowledge_Products"   = $null
            "Learning_Events"      = $null
            "Beneficiary_Feedback" = $null
        }
        "Data_Management" = [ordered]@{
            "Tools_and_Forms" = $null
            "Raw_Data"        = $null
            "Clean_Data"      = $null
            "Code_and_Syntax" = $null
            "Analysis"        = [ordered]@{
                "Data"           = $null
                "Output_Tables"  = $null
                "Output_Figures" = $null
            }
            "Beneficiary_Database"        = $null
            "Data_Protection_and_Consent" = $null
            "Supplementary_Data"          = $null
        }
        "Reporting" = [ordered]@{
            "Donor_Reports"    = $null
            "Internal_Reports" = $null
            "Event_Reports"    = $null
            "Incident_Reports" = $null
            "Dashboards"       = $null
            "Presentations"    = $null
        }
        "Communications_and_Visibility" = [ordered]@{
            "Banners_and_Posters" = $null
            "Media_and_Photos"    = $null
        }
    }

    "Business_Development" = [ordered]@{
        "Admin" = [ordered]@{
            "Team_ToRs_and_Job_Descriptions" = $null
            "Meeting_Minutes"                = $null
            "Correspondence"                 = $null
        }
        "Donor_Intelligence" = [ordered]@{
            "Donor_Profiles"        = $null
            "Funding_Opportunities" = $null
            "Donor_Mapping"         = $null
        }
        "Proposal_Development" = [ordered]@{
            "Concept_Notes"    = $null
            "Full_Proposals"   = $null
            "Budgets"          = $null
            "Logframe_and_ToC" = $null
            "Annexes"          = $null
        }
        "Partnerships" = [ordered]@{
            "MOUs_and_Agreements"  = $null
            "Partner_Profiles"     = $null
            "Consortium_Documents" = $null
        }
        "Research_and_Business_Intelligence" = [ordered]@{
            "Market_Analysis"     = $null
            "Needs_Assessments"   = $null
            "Competitor_Analysis" = $null
        }
        "Compliance_and_Due_Diligence" = [ordered]@{
            "Donor_Compliance_Checklists"        = $null
            "Organizational_Capacity_Statements" = $null
            "Registration_and_Legal_Documents"   = $null
        }
        "Communications_and_Branding" = [ordered]@{
            "Case_for_Support" = $null
            "Pitch_Decks"      = $null
            "Success_Stories"  = $null
        }
        "Reporting" = [ordered]@{
            "Pipeline_Tracker"     = $null
            "Win_Loss_Analysis"    = $null
            "Internal_BD_Reports" = $null
        }
    }

    "Project_Management" = [ordered]@{
        "Admin" = [ordered]@{
            "Project_Charter"    = $null
            "ToRs_and_Contracts" = $null
            "Meeting_Minutes"    = $null
            "Correspondence"     = $null
        }
        "Planning" = [ordered]@{
            "Workplan_and_Gantt_Chart" = $null
            "Logframe_and_ToC"         = $null
            "Risk_Register"            = $null
            "Procurement_Plan"         = $null
        }
        "Budget_and_Finance" = [ordered]@{
            "Budget_and_Forecast"  = $null
            "Expenditure_Tracking" = $null
            "Financial_Reports"    = $null
        }
        "Implementation" = [ordered]@{
            "Activity_Reports"    = $null
            "Field_Visit_Reports" = $null
            "Deliverables"        = $null
        }
        "HR_and_Team" = [ordered]@{
            "Staffing_Plan"        = $null
            "Onboarding_Documents" = $null
            "Team_Contact_List"    = $null
        }
        "Procurement_and_Logistics" = [ordered]@{
            "Purchase_Requests" = $null
            "Vendor_Contracts"  = $null
            "Asset_Inventory"   = $null
        }
        "Reporting" = [ordered]@{
            "Donor_Reports"    = $null
            "Internal_Reports" = $null
            "Dashboards"       = $null
        }
        "Risk_and_Issue_Management" = [ordered]@{
            "Risk_Log"        = $null
            "Issue_Log"       = $null
            "Lessons_Learned" = $null
        }
        "Closeout" = [ordered]@{
            "Handover_Documents" = $null
            "Final_Report"       = $null
            "Asset_Disposal"     = $null
        }
    }
}

#region --- 2. DEFAULTS -------------------------------------------------
$Script:DefaultAuthor = "Asadullah All Galib"
$Script:DefaultEmail  = "galib.ihe.du.bd@gmail.com"
$Script:ToolDeveloper = "Asadullah All Galib (galib.ihe.du.bd@gmail.com)"

# Folder names that should be flagged as sensitive/restricted if created
$Script:SensitiveFolderNames = @(
    "Safeguarding_and_PSEA",
    "Beneficiary_Database",
    "Data_Protection_and_Consent"
)
#endregion

#region --- 3. TREE HELPERS (build / sync / extract / create) ----------

# Recursively builds TreeNodes in the dialog from a nested structure
function Build-FolderTreeNodes {
    param(
        [System.Windows.Forms.TreeNodeCollection]$Collection,
        $Tree
    )
    foreach ($key in $Tree.Keys) {
        $node = New-Object System.Windows.Forms.TreeNode($key)
        $node.Checked = $true
        if ($null -ne $Tree[$key]) {
            Build-FolderTreeNodes -Collection $node.Nodes -Tree $Tree[$key]
        }
        $Collection.Add($node) | Out-Null
    }
}

# Ticks/unticks every descendant of a node to match the node's own state
function Set-DescendantChecked {
    param($Node, [bool]$IsChecked)
    foreach ($child in $Node.Nodes) {
        $child.Checked = $IsChecked
        Set-DescendantChecked -Node $child -IsChecked $IsChecked
    }
}

# Walks up from a node, re-deriving each ancestor's checked state
# (an ancestor is checked if ANY of its children are checked)
function Update-AncestorChecked {
    param($Node)
    for ($parent = $Node.Parent; $null -ne $parent; $parent = $parent.Parent) {
        $parent.Checked = @($parent.Nodes | Where-Object Checked).Count -gt 0
    }
}

# Extracts only the CHECKED nodes into a plain nested ordered hashtable
# (same shape as $Script:DepartmentStructures), preserving on-screen order
function Get-CheckedFolderTree {
    param([System.Windows.Forms.TreeNodeCollection]$Collection)
    $result = [ordered]@{}
    foreach ($node in $Collection) {
        if (-not $node.Checked) { continue }
        $result[$node.Text] = if ($node.Nodes.Count -gt 0) {
            Get-CheckedFolderTree -Collection $node.Nodes
        } else { $null }
    }
    return $result
}

# Recursively creates folders from a nested tree, auto-numbering each
# level 01, 02, 03... based only on the entries actually present
function New-FoldersFromTree {
    param([string]$ParentPath, $Tree)
    $i = 0
    foreach ($key in $Tree.Keys) {
        $i++
        $folderPath = Join-Path $ParentPath ("{0:D2}_{1}" -f $i, $key)
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
        if ($null -ne $Tree[$key]) {
            New-FoldersFromTree -ParentPath $folderPath -Tree $Tree[$key]
        }
    }
}
#endregion

#region --- 4. THE CUSTOMIZATION DIALOG --------------------------------
function Show-ProjectFolderDialog {
    param(
        [string]$InitialPath,
        [string]$InitialProjectName,
        [string]$InitialDepartment = "MEAL"
    )

    # --- layout constants, so the form is easy to re-tune later ---
    $marginX      = 15
    $labelWidth   = 150
    $fieldX       = 170
    $fieldWidth   = 390
    $rowHeight    = 32

    $form                 = New-Object System.Windows.Forms.Form
    $form.Text            = "NgoProjectFold - Project Folder Setup"
    $form.Size            = New-Object System.Drawing.Size(600, 730)
    $form.StartPosition   = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox     = $false

    $y = $marginX

    function New-Label([string]$Text, [int]$Y, [int]$Width = $labelWidth) {
        $lbl = New-Object System.Windows.Forms.Label
        $lbl.Text = $Text
        $lbl.Location = New-Object System.Drawing.Point($marginX, $Y)
        $lbl.Size = New-Object System.Drawing.Size($Width, 20)
        $form.Controls.Add($lbl)
        return $lbl
    }

    # --- Department picker: the ONE thing that changes what you see ---
    New-Label "Department:" $y | Out-Null
    $cmbDept = New-Object System.Windows.Forms.ComboBox
    $cmbDept.Location = New-Object System.Drawing.Point($fieldX, ($y - 3))
    $cmbDept.Size = New-Object System.Drawing.Size($fieldWidth, 20)
    $cmbDept.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    foreach ($dept in $Script:DepartmentStructures.Keys) { $cmbDept.Items.Add($dept) | Out-Null }
    $cmbDept.SelectedItem = if ($cmbDept.Items.Contains($InitialDepartment)) { $InitialDepartment } else { $cmbDept.Items[0] }
    $form.Controls.Add($cmbDept)
    $y += $rowHeight

    # --- Project name ---
    New-Label "Project name:" $y | Out-Null
    $txtProject = New-Object System.Windows.Forms.TextBox
    $txtProject.Location = New-Object System.Drawing.Point($fieldX, ($y - 3))
    $txtProject.Size = New-Object System.Drawing.Size($fieldWidth, 20)
    $txtProject.Text = $InitialProjectName
    $form.Controls.Add($txtProject)
    $y += $rowHeight

    # --- Destination path (+ Browse) ---
    New-Label "Destination path:" $y | Out-Null
    $txtPath = New-Object System.Windows.Forms.TextBox
    $txtPath.Location = New-Object System.Drawing.Point($fieldX, ($y - 3))
    $txtPath.Size = New-Object System.Drawing.Size(310, 20)
    $txtPath.Text = $InitialPath
    $form.Controls.Add($txtPath)

    $btnBrowse = New-Object System.Windows.Forms.Button
    $btnBrowse.Text = "Browse..."
    $btnBrowse.Location = New-Object System.Drawing.Point(490, ($y - 4))
    $btnBrowse.Size = New-Object System.Drawing.Size(70, 23)
    $btnBrowse.Add_Click({
        $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($fbd.ShowDialog() -eq "OK") { $txtPath.Text = $fbd.SelectedPath }
    })
    $form.Controls.Add($btnBrowse)
    $y += $rowHeight

    # --- Author / Email ---
    New-Label "Author:" $y | Out-Null
    $txtAuthor = New-Object System.Windows.Forms.TextBox
    $txtAuthor.Location = New-Object System.Drawing.Point($fieldX, ($y - 3))
    $txtAuthor.Size = New-Object System.Drawing.Size($fieldWidth, 20)
    $txtAuthor.Text = $Script:DefaultAuthor
    $form.Controls.Add($txtAuthor)
    $y += 28

    New-Label "Email:" $y | Out-Null
    $txtEmail = New-Object System.Windows.Forms.TextBox
    $txtEmail.Location = New-Object System.Drawing.Point($fieldX, ($y - 3))
    $txtEmail.Size = New-Object System.Drawing.Size($fieldWidth, 20)
    $txtEmail.Text = $Script:DefaultEmail
    $form.Controls.Add($txtEmail)
    $y += 36

    # --- Folder tree label + Add Master/Sub buttons ---
    New-Label "Tick/untick folders, or add your own below (numbers are automatic):" $y 550 | Out-Null
    $y += 22

    $btnAddMaster = New-Object System.Windows.Forms.Button
    $btnAddMaster.Text = "+ New Master Folder"
    $btnAddMaster.Location = New-Object System.Drawing.Point($marginX, $y)
    $btnAddMaster.Size = New-Object System.Drawing.Size(170, 26)
    $form.Controls.Add($btnAddMaster)

    $btnAddSub = New-Object System.Windows.Forms.Button
    $btnAddSub.Text = "+ New Sub-folder"
    $btnAddSub.Location = New-Object System.Drawing.Point(195, $y)
    $btnAddSub.Size = New-Object System.Drawing.Size(170, 26)
    $form.Controls.Add($btnAddSub)
    $y += 34

    # --- Folder tree (checkboxes) ---
    $treeView = New-Object System.Windows.Forms.TreeView
    $treeView.Location = New-Object System.Drawing.Point($marginX, $y)
    $treeView.Size = New-Object System.Drawing.Size(550, 380)
    $treeView.CheckBoxes = $true

    # NOTE: this must be a scriptblock stored in a variable, not a
    # nested "function" - .GetNewClosure() below only captures
    # variables, not locally-defined functions, so a nested function
    # here would go out of scope by the time the event actually fires.
    $syncTreeToDepartment = {
        param([string]$Department)
        $treeView.Nodes.Clear()
        Build-FolderTreeNodes -Collection $treeView.Nodes -Tree $Script:DepartmentStructures[$Department]
        $treeView.ExpandAll()
    }
    & $syncTreeToDepartment $cmbDept.SelectedItem

    $cmbDept.Add_SelectedIndexChanged({ & $syncTreeToDepartment $cmbDept.SelectedItem }.GetNewClosure())

    $treeView.Add_AfterCheck({
        param($sender, $e)
        if ($e.Action -eq [System.Windows.Forms.TreeViewAction]::Unknown) { return }
        Set-DescendantChecked -Node $e.Node -IsChecked $e.Node.Checked
        Update-AncestorChecked -Node $e.Node
    })

    $btnAddMaster.Add_Click({
        $name = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Name of the new master (top-level) folder:", "New Master Folder", "")
        if (-not [string]::IsNullOrWhiteSpace($name)) {
            $newTop = New-Object System.Windows.Forms.TreeNode($name.Trim())
            $newTop.Checked = $true
            $treeView.Nodes.Add($newTop) | Out-Null
            $treeView.SelectedNode = $newTop
            $newTop.EnsureVisible()
        }
    }.GetNewClosure())

    $btnAddSub.Add_Click({
        $target = $treeView.SelectedNode
        if ($null -eq $target) {
            [System.Windows.Forms.MessageBox]::Show(
                "First click a folder in the list below, to choose where the new sub-folder goes.",
                "Select a folder first") | Out-Null
            return
        }
        $name = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Name of the new sub-folder (inside '$($target.Text)'):", "New Sub-folder", "")
        if (-not [string]::IsNullOrWhiteSpace($name)) {
            $newSub = New-Object System.Windows.Forms.TreeNode($name.Trim())
            $newSub.Checked = $true
            $target.Nodes.Add($newSub) | Out-Null
            $target.Expand()
            $target.Checked = $true
            $treeView.SelectedNode = $newSub
        }
    }.GetNewClosure())

    $form.Controls.Add($treeView)
    $y += 390

    # --- Create / Cancel ---
    $btnCreate = New-Object System.Windows.Forms.Button
    $btnCreate.Text = "Create Folders"
    $btnCreate.Location = New-Object System.Drawing.Point(375, $y)
    $btnCreate.Size = New-Object System.Drawing.Size(120, 30)
    $btnCreate.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($btnCreate)
    $form.AcceptButton = $btnCreate

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Cancel"
    $btnCancel.Location = New-Object System.Drawing.Point(245, $y)
    $btnCancel.Size = New-Object System.Drawing.Size(120, 30)
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($btnCancel)
    $form.CancelButton = $btnCancel

    if ($form.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return $null }

    if ([string]::IsNullOrWhiteSpace($txtProject.Text) -or [string]::IsNullOrWhiteSpace($txtPath.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Project name and path are both required.", "Missing info") | Out-Null
        return $null
    }

    return @{
        Department  = $cmbDept.SelectedItem
        ProjectName = $txtProject.Text.Trim()
        Path        = $txtPath.Text.Trim()
        Author      = $txtAuthor.Text.Trim()
        Email       = $txtEmail.Text.Trim()
        Tree        = Get-CheckedFolderTree -Collection $treeView.Nodes
    }
}
#endregion

#region --- 5. THE ONE COMMAND ------------------------------------------
function New-ProjectFolder {
    <#
    .SYNOPSIS
        Creates a customized project folder structure for the MEAL,
        Business_Development, or Project_Management department.
    .DESCRIPTION
        Just run:  New-ProjectFolder -Path "D:\Projects"
        A dialog box opens where you pick your department and
        customize the folder list - the same one command works for
        everyone, in every department.
    .EXAMPLE
        New-ProjectFolder -Path "D:\NGO\Projects"
    .EXAMPLE
        New-ProjectFolder -Path "D:\NGO\Projects" -ProjectName "ProjectX" -Department Project_Management -NoGui
    .NOTES
        Tool developed by Asadullah All Galib (galib.ihe.du.bd@gmail.com)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [string]$ProjectName,

        [ValidateSet("MEAL", "Business_Development", "Project_Management")]
        [string]$Department = "MEAL",

        [string]$Author = $Script:DefaultAuthor,
        [string]$Email = $Script:DefaultEmail,

        # Advanced: skip the dialog and create the full default
        # structure for -Department immediately
        [switch]$NoGui
    )

    if ($NoGui) {
        if ([string]::IsNullOrWhiteSpace($ProjectName)) {
            throw "Please provide -ProjectName when using -NoGui."
        }
        $chosenTree   = $Script:DepartmentStructures[$Department]
        $finalPath    = $Path
        $finalProject = $ProjectName
        $finalAuthor  = $Author
        $finalEmail   = $Email
    }
    else {
        $selection = Show-ProjectFolderDialog -InitialPath $Path -InitialProjectName $ProjectName -InitialDepartment $Department
        if ($null -eq $selection) {
            Write-Host "Cancelled - no folders created." -ForegroundColor Yellow
            return
        }
        $chosenTree   = $selection.Tree
        $finalPath    = $selection.Path
        $finalProject = $selection.ProjectName
        $finalAuthor  = $selection.Author
        $finalEmail   = $selection.Email
        $Department   = $selection.Department
    }

    $root = Join-Path $finalPath $finalProject
    if (Test-Path $root) {
        Write-Host "The folder '$root' already exists. Choose a different project name or location." -ForegroundColor Red
        return
    }

    New-Item -ItemType Directory -Path $root | Out-Null
    New-FoldersFromTree -ParentPath $root -Tree $chosenTree

    # Flag any sensitive folders that were actually created this run
    $sensitiveFound = Get-ChildItem -Path $root -Recurse -Directory |
        Where-Object { $Script:SensitiveFolderNames -contains ($_.Name -replace '^\d+_', '') }

    $info = @"
Project    : $finalProject
Department : $Department
Author     : $finalAuthor
Email      : $finalEmail
Created    : $(Get-Date -Format "yyyy-MM-dd HH:mm")

Generated by NgoProjectFold - tool developed by $Script:ToolDeveloper
"@

    if ($sensitiveFound) {
        $info += "`n`nREMINDER: The following folder(s) may hold sensitive or personally`nidentifiable information. Right-click each -> Properties -> Security`nand restrict access to only the staff who need it:`n"
        foreach ($f in $sensitiveFound) {
            $info += "  - $($f.FullName.Substring($root.Length + 1))`n"
        }
    }

    Set-Content -Path (Join-Path $root "ProjectInfo.txt") -Value $info -Encoding UTF8

    Write-Host "Done! Folder structure created at: $root" -ForegroundColor Green
    Invoke-Item $root
}
#endregion

Export-ModuleMember -Function New-ProjectFolder, Show-ProjectFolderDialog
