@{
    RootModule        = 'NgoProjectFold.psm1'
    ModuleVersion      = '2.0.0'
    GUID               = 'b3e2b5b0-6a1f-4b8a-9a2b-5c1e7d6f8a90'
    Author             = 'Asadullah All Galib'
    CompanyName        = 'Unknown'
    Copyright          = '(c) 2026 Asadullah All Galib. MIT License.'
    Description        = 'One shared command (New-ProjectFolder) that creates a customizable project folder structure for the MEAL, Business_Development, or Project_Management department, picked from a dialog box dropdown. Developed by Asadullah All Galib (galib.ihe.du.bd@gmail.com).'
    PowerShellVersion  = '5.1'
    FunctionsToExport  = @('New-ProjectFolder', 'Show-ProjectFolderDialog')
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData = @{
        PSData = @{
            Tags = @('NGO', 'MEAL', 'ProjectManagement', 'BusinessDevelopment', 'FolderStructure')
            ProjectUri = 'https://github.com/Galib07/ngoprojectfold'
        }
    }
}
