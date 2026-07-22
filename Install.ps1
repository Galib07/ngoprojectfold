<#
    Install.ps1  --  NgoProjectFold installer
    ------------------------------------------------------------------
    Developed by : Asadullah All Galib (galib.ihe.du.bd@gmail.com)
    Repository   : https://github.com/Galib07/ngoprojectfold

    Anyone on the MEAL, Business_Development, or Project_Management
    team can install AND immediately use it with just this one line:

        irm https://raw.githubusercontent.com/Galib07/ngoprojectfold/main/Install.ps1 | iex

    This script:
        1. Creates an "NgoProjectFold" folder inside the user's
           personal PowerShell Modules directory
        2. Downloads NgoProjectFold.psm1 and NgoProjectFold.psd1 from
           GitHub into it
        3. Adds "Import-Module NgoProjectFold" to the user's $PROFILE,
           so New-ProjectFolder is available automatically in every
           future PowerShell window (no re-install needed later)
        4. Immediately imports the module IN THIS SAME WINDOW and
           opens the folder-setup dialog box - no need to close or
           reopen PowerShell, and no second command to type
    ------------------------------------------------------------------
#>

$ErrorActionPreference = "Stop"

$GitHubUser = "Galib07"
$GitHubRepo = "ngoprojectfold"
$Branch     = "main"
$ModuleName = "NgoProjectFold"

$BaseUrl = "https://raw.githubusercontent.com/$GitHubUser/$GitHubRepo/$Branch"

# Personal module path (works for Windows PowerShell 5.1 and PowerShell 7+)
$ModulesRoot = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "WindowsPowerShell\Modules"
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $ModulesRoot = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Modules"
}

$TargetDir = Join-Path $ModulesRoot $ModuleName
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Write-Host "Downloading $ModuleName..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BaseUrl/$ModuleName.psm1" -OutFile (Join-Path $TargetDir "$ModuleName.psm1")
Invoke-WebRequest -Uri "$BaseUrl/$ModuleName.psd1" -OutFile (Join-Path $TargetDir "$ModuleName.psd1")

# Make sure the profile file exists, and set it up for FUTURE sessions
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
}

$importLine = "Import-Module $ModuleName"
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notmatch [regex]::Escape($importLine)) {
    Add-Content -Path $PROFILE -Value "`n$importLine"
    Write-Host "Added '$importLine' to your PowerShell profile (so it's ready automatically next time too)." -ForegroundColor Green
}
else {
    Write-Host "Profile already set up to import $ModuleName." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Install complete! Opening the folder-setup window now..." -ForegroundColor Green
Write-Host ""

# --- Load it and run it right now, in THIS SAME PowerShell window ---
Import-Module (Join-Path $TargetDir "$ModuleName.psd1") -Force
New-ProjectFolder -Path (Get-Location).Path
