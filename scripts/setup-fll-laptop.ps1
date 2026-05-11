<#
.SYNOPSIS
    Standardized setup script for Bolton Robotics FLL chapter laptops.

.DESCRIPTION
    Run this script ONCE per donated laptop, while logged in as the
    student team account (which has temporary or permanent admin privileges).

    Pass the team number as the first argument, or run with no arguments
    to see the team menu and be prompted.

    The script:
      1. Installs core software (Git, Python, VS Code, Chrome, GitHub Desktop) via winget
      2. Writes a chapter-standard .gitconfig to the user's home directory
      3. Installs VS Code extensions and configures the integrated terminal
      4. Sets Chrome as default browser, unpins Edge from taskbar
      5. Quiets Windows notifications, disables suggested content / ads
      6. Configures power plan, Windows Update active hours
      7. Creates the team's repo folder, app shortcuts, and team shortcuts on the desktop

    What it does NOT do (these are interactive, do them manually after):
      - Sign in to Chrome with the team email
      - Set up GitHub authentication (HTTPS credential manager or SSH key)
      - Clone the team's spike_basecode fork
      - Install the Pybricks firmware on the SPIKE Prime hub
      - Pin shortcuts to the taskbar (Microsoft removed scripted pinning;
        right-click each desktop shortcut and choose "Pin to taskbar")

.NOTES
    Author:   Steven Erat with Claude (Bolton Robotics chapter)
    Audience: FLL chapter coaches provisioning team laptops
    Tested on: Windows 11 (should also work on Windows 10 with winget installed)

    Run as Administrator from PowerShell:
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
        .\setup-fll-laptop.ps1 27041
#>

# =============================================================================
# TEAM SELECTION
# =============================================================================

param(
    [Parameter(Position = 0)]
    [string]$TeamNumber
)

# Known chapter teams. Each entry has a team name (or $null if unnamed) and
# the team's current email address. Email may be @outlook.com or @gmail.com
# depending on what we were able to provision; update here when emails change.
$KnownTeams = @{
    "18300" = @{ Name = $null;             Email = "fss.fll.18300@outlook.com" }
    "19991" = @{ Name = $null;             Email = "fss.fll.19991@outlook.com" }
    "27041" = @{ Name = "Thought Process"; Email = "fss.fll.27041@gmail.com"   }
    "27042" = @{ Name = $null;             Email = "fss.fll.27042@gmail.com"   }
    "62070" = @{ Name = $null;             Email = "fss.fll.62070@outlook.com" }
}

# If no team number was passed, show the menu and prompt
if (-not $TeamNumber) {
    Write-Host ""
    Write-Host "Bolton Robotics FLL - known teams:" -ForegroundColor Cyan
    foreach ($t in $KnownTeams.Keys | Sort-Object) {
        $label = if ($KnownTeams[$t].Name) { $KnownTeams[$t].Name } else { "(unnamed)" }
        Write-Host "  $t  $label"
    }
    Write-Host ""
    $TeamNumber = Read-Host "Enter team number for this laptop"
}

# Validate
if (-not $KnownTeams.ContainsKey($TeamNumber)) {
    Write-Error "Team number '$TeamNumber' is not in the known teams list. Edit `$KnownTeams in this script if this is a new team."
    exit 1
}

# Resolve team name (use known name if set, otherwise default to chapter convention)
$TeamName = if ($KnownTeams[$TeamNumber].Name) {
    $KnownTeams[$TeamNumber].Name
} else {
    "Bolton Robotics Team $TeamNumber"
}

# Derived team-specific values
$TeamEmail     = $KnownTeams[$TeamNumber].Email          # @gmail.com or @outlook.com per team
$GitUserName   = "Bolton Robotics FLL Team $TeamNumber"  # Shows up in commit history
$GitUserEmail  = $TeamEmail                              # Same as the team email
$GitHubUser    = "fssfll$TeamNumber"                     # Team's GitHub username (convention)
$ForkUrl       = "https://github.com/$GitHubUser/spike_basecode.git"
$UpstreamUrl   = "https://github.com/stevenerat/spike_basecode.git"

# Local paths
$ReposRoot     = "$env:USERPROFILE\repos"
$RepoPath      = "$ReposRoot\spike_basecode"
$DesktopPath   = [Environment]::GetFolderPath("Desktop")
$GitConfigPath = "$env:USERPROFILE\.gitconfig"

# =============================================================================
# PRELIMINARIES
# =============================================================================

# Stop on errors so failures are visible rather than silent
$ErrorActionPreference = "Stop"

# Verify we're running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Right-click PowerShell -> Run as Administrator."
    exit 1
}

Write-Host ""
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host " FLL Laptop Setup - Team $TeamNumber ($TeamName)" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host ""

# =============================================================================
# 1. SOFTWARE INSTALLATION VIA WINGET
# =============================================================================

Write-Host "[1/7] Installing core software via winget..." -ForegroundColor Yellow

# winget package IDs (exact, version-pinned where it matters)
$packages = @(
    @{ Id = "Git.Git";                       Name = "Git for Windows" },
    @{ Id = "Python.Python.3.12";            Name = "Python 3.12" },
    @{ Id = "Microsoft.VisualStudioCode";    Name = "VS Code" },
    @{ Id = "Google.Chrome";                 Name = "Google Chrome" },
    @{ Id = "GitHub.GitHubDesktop";          Name = "GitHub Desktop" }
)

foreach ($pkg in $packages) {
    Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Gray
    winget install --id $pkg.Id --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        # -1978335189 = "already installed", which is fine
        Write-Warning "winget reported exit code $LASTEXITCODE for $($pkg.Name). Continuing."
    }
}

# Refresh PATH so newly-installed tools are findable in this session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "  Software install complete." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 2. GIT CONFIGURATION (.gitconfig)
# =============================================================================

Write-Host "[2/7] Writing chapter-standard .gitconfig..." -ForegroundColor Yellow

# Adapted from Steve's Mac .gitconfig with Windows-specific adjustments:
#   - core.autocrlf changed from "input" to "true" (Windows line-ending convention)
#   - filter "lfs" section removed (Git LFS not installed; chapter repo doesn't use it)
#   - Added init.defaultBranch, pull.rebase, credential.helper
#
# Re-running this script OVERWRITES the .gitconfig file - any manual edits will be lost.

$gitConfigContent = @"
# ~/.gitconfig - FLL chapter laptop
# Adapted from Steve's Mac .gitconfig with Windows-specific adjustments.
# Generated by setup-fll-laptop.ps1 - re-running the script overwrites this file.

[user]
    name = $GitUserName
    email = $GitUserEmail

[init]
    defaultBranch = main

[pull]
    rebase = false                   # Default to merge on pull, not rebase

[credential]
    helper = manager                 # Windows Credential Manager for GitHub auth

[color]
    ui = auto

[color "status"]
    added = green
    changed = yellow
    untracked = red

[color "diff"]
    meta = cyan
    frag = magenta
    old = red
    new = green

[color "branch"]
    current = yellow bold
    local = green
    remote = cyan

[core]
    editor = code --wait             # VS Code as default editor
    pager = less -FRSX               # Better pager (works in Git Bash)
    autocrlf = true                  # Windows: CRLF in working tree, LF in repo

[help]
    autocorrect = 20                 # Auto-run corrected commands after 2 sec

[merge]
    conflictstyle = diff3            # Show base version during conflicts

[blame]
    coloring = highlightRecent

[diff]
    tool = vimdiff

[difftool]
    prompt = false

[alias]
    st = status -sb
    lg = log --graph --decorate --oneline --all
    lga = log --graph --decorate --pretty=oneline --abbrev-commit --all
    undo = reset --soft HEAD~1
"@

Set-Content -Path $GitConfigPath -Value $gitConfigContent -Encoding UTF8

Write-Host "  .gitconfig written to $GitConfigPath" -ForegroundColor Green
Write-Host "  Configured for $GitUserName <$GitUserEmail>." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 3. VS CODE EXTENSIONS AND SETTINGS
# =============================================================================

Write-Host "[3/7] Installing VS Code extensions and configuring settings..." -ForegroundColor Yellow

$vscodeExtensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "eamodio.gitlens",
    "ms-vscode.powershell"
    # Add more as needed
)

foreach ($ext in $vscodeExtensions) {
    Write-Host "  Installing extension: $ext" -ForegroundColor Gray
    code --install-extension $ext --force 
}

# Configure VS Code user settings - make Git Bash the default terminal
$vscodeSettingsDir  = "$env:APPDATA\Code\User"
$vscodeSettingsPath = "$vscodeSettingsDir\settings.json"

if (-not (Test-Path $vscodeSettingsDir)) {
    New-Item -ItemType Directory -Path $vscodeSettingsDir -Force 
}

$vscodeSettings = @{
    "terminal.integrated.defaultProfile.windows" = "Git Bash"
    "editor.formatOnSave"                        = $true
    "files.trimTrailingWhitespace"               = $true
    "files.insertFinalNewline"                   = $true
    "telemetry.telemetryLevel"                   = "off"
    "update.showReleaseNotes"                    = $false
    "workbench.startupEditor"                    = "none"
    "explorer.confirmDragAndDrop"                = $false
}

$vscodeSettings | ConvertTo-Json -Depth 5 | Set-Content -Path $vscodeSettingsPath -Encoding UTF8

Write-Host "  VS Code configured." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 4. BROWSER AND TASKBAR CLEANUP
# =============================================================================

Write-Host "[4/7] Configuring browser defaults and cleaning up taskbar..." -ForegroundColor Yellow

# Chrome as default browser cannot be set silently in modern Windows without
# admin SetUserFTA tooling. We'll prompt the user instead.
Write-Host "  NOTE: Setting Chrome as default browser must be done manually." -ForegroundColor Cyan
Write-Host "        After this script finishes, open Settings > Apps > Default apps" -ForegroundColor Cyan
Write-Host "        > Google Chrome > Set default." -ForegroundColor Cyan

# Unpin Edge from taskbar (works on Windows 11)
# This uses a registry-based approach since Microsoft has removed the COM verb
try {
    $edgeShortcut = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk"
    if (Test-Path $edgeShortcut) {
        Remove-Item $edgeShortcut -Force
        Write-Host "  Removed Edge taskbar pin." -ForegroundColor Gray
    }
} catch {
    Write-Warning "Could not remove Edge taskbar pin automatically. Right-click and unpin manually."
}

Write-Host "  Browser/taskbar cleanup complete." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 5. QUIET WINDOWS - NOTIFICATIONS, ADS, SUGGESTED CONTENT
# =============================================================================

Write-Host "[5/7] Quieting Windows notifications and ads..." -ForegroundColor Yellow

# Disable "suggested content" in Settings app
$contentDeliveryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$suggestedKeys = @(
    "SubscribedContent-338388Enabled",   # Start menu suggestions
    "SubscribedContent-338389Enabled",   # Tips, tricks suggestions
    "SubscribedContent-353694Enabled",   # Settings app suggestions
    "SubscribedContent-353696Enabled",   # Settings app suggestions
    "SilentInstalledAppsEnabled",        # Auto-installed promoted apps
    "SystemPaneSuggestionsEnabled"       # Start menu app suggestions
)
foreach ($key in $suggestedKeys) {
    Set-ItemProperty -Path $contentDeliveryPath -Name $key -Value 0 -Type DWord -Force
}

# Disable web search results in Start menu
$searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
if (-not (Test-Path $searchPath)) { New-Item -Path $searchPath -Force }
Set-ItemProperty -Path $searchPath -Name "BingSearchEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $searchPath -Name "CortanaConsent"    -Value 0 -Type DWord -Force

# Disable lock screen ads / suggestions
Set-ItemProperty -Path $contentDeliveryPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $contentDeliveryPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord -Force

# Disable OneDrive auto-sync prompts (does not uninstall OneDrive, just stops the nagging)
$oneDrivePath = "HKCU:\Software\Microsoft\OneDrive"
if (-not (Test-Path $oneDrivePath)) { New-Item -Path $oneDrivePath -Force }
Set-ItemProperty -Path $oneDrivePath -Name "DisablePersonalSync" -Value 1 -Type DWord -Force

Write-Host "  Windows quieted." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 6. POWER PLAN AND WINDOWS UPDATE
# =============================================================================

Write-Host "[6/7] Configuring power plan and Windows Update..." -ForegroundColor Yellow

# Set sleep timeout to 60 minutes when plugged in (default is often 10-15)
powercfg /change standby-timeout-ac 60
powercfg /change monitor-timeout-ac 30
powercfg /change disk-timeout-ac    0      # Never spin down disk on AC

# Set Windows Update active hours: 8 AM to 8 PM (covers all reasonable meeting times)
$wuPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
if (-not (Test-Path $wuPath)) { New-Item -Path $wuPath -Force }
Set-ItemProperty -Path $wuPath -Name "ActiveHoursStart" -Value 8  -Type DWord -Force
Set-ItemProperty -Path $wuPath -Name "ActiveHoursEnd"   -Value 20 -Type DWord -Force

Write-Host "  Power plan and update hours configured." -ForegroundColor Green
Write-Host ""

# =============================================================================
# 7. REPO FOLDER, DESKTOP SHORTCUTS, README
# =============================================================================

Write-Host "[7/7] Creating repo folder and desktop shortcuts..." -ForegroundColor Yellow

# Create repo parent folder
if (-not (Test-Path $ReposRoot)) {
    New-Item -ItemType Directory -Path $ReposRoot -Force 
}

# Helper function to create .lnk shortcuts
function New-Shortcut {
    param(
        [string]$Path,
        [string]$Target,
        [string]$Arguments = "",
        [string]$WorkingDirectory = "",
        [string]$IconLocation = ""
    )
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($Path)
    $shortcut.TargetPath = $Target
    if ($Arguments)        { $shortcut.Arguments = $Arguments }
    if ($WorkingDirectory) { $shortcut.WorkingDirectory = $WorkingDirectory }
    if ($IconLocation)     { $shortcut.IconLocation = $IconLocation }
    $shortcut.Save()
}

# -----------------------------------------------------------------------------
# General app shortcuts (not team-specific)
# -----------------------------------------------------------------------------

# Chrome - try standard Program Files location, fall back to (x86)
$chromeExe = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chromeExe)) {
    $chromeExe = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
}
if (Test-Path $chromeExe) {
    New-Shortcut -Path "$DesktopPath\Google Chrome.lnk" -Target $chromeExe
    Write-Host "  Created shortcut: Google Chrome" -ForegroundColor Gray
} else {
    Write-Warning "  Chrome executable not found; skipping Chrome shortcut."
}

# GitHub Desktop - installs per-user under LOCALAPPDATA
$githubDesktopExe = "$env:LOCALAPPDATA\GitHubDesktop\GitHubDesktop.exe"
if (-not (Test-Path $githubDesktopExe)) {
    # Versioned subdirectory fallback (some installer versions)
    $candidate = Get-ChildItem "$env:LOCALAPPDATA\GitHubDesktop" -Filter "GitHubDesktop.exe" `
                    -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($candidate) { $githubDesktopExe = $candidate.FullName }
}
if (Test-Path $githubDesktopExe) {
    New-Shortcut -Path "$DesktopPath\GitHub Desktop.lnk" -Target $githubDesktopExe
    Write-Host "  Created shortcut: GitHub Desktop" -ForegroundColor Gray
} else {
    Write-Warning "  GitHub Desktop executable not found; skipping shortcut."
}

# VS Code - try user install first, then system install
$vscodeExe = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (-not (Test-Path $vscodeExe)) {
    $vscodeExe = "${env:ProgramFiles}\Microsoft VS Code\Code.exe"
}
if (Test-Path $vscodeExe) {
    New-Shortcut -Path "$DesktopPath\Visual Studio Code.lnk" -Target $vscodeExe
    Write-Host "  Created shortcut: Visual Studio Code" -ForegroundColor Gray
} else {
    Write-Warning "  VS Code executable not found; skipping general VS Code shortcut."
}

# File Explorer - built-in, always present
New-Shortcut -Path "$DesktopPath\File Explorer.lnk" -Target "explorer.exe"
Write-Host "  Created shortcut: File Explorer" -ForegroundColor Gray

# Command Prompt - built-in, always present
New-Shortcut -Path "$DesktopPath\Command Prompt.lnk" -Target "$env:SystemRoot\System32\cmd.exe"
Write-Host "  Created shortcut: Command Prompt" -ForegroundColor Gray

# -----------------------------------------------------------------------------
# Team-specific workflow shortcuts
# -----------------------------------------------------------------------------

# Shortcut: Open Team Code in VS Code (pre-loaded with the repo folder)
if (Test-Path $vscodeExe) {
    New-Shortcut `
        -Path "$DesktopPath\Open Team $TeamNumber Code.lnk" `
        -Target $vscodeExe `
        -Arguments "`"$RepoPath`"" `
        -WorkingDirectory $RepoPath
    Write-Host "  Created shortcut: Open Team $TeamNumber Code" -ForegroundColor Gray
}

# Shortcut: Team's repo folder (File Explorer)
New-Shortcut `
    -Path "$DesktopPath\Team $TeamNumber Repo Folder.lnk" `
    -Target "explorer.exe" `
    -Arguments "`"$RepoPath`""
Write-Host "  Created shortcut: Team $TeamNumber Repo Folder" -ForegroundColor Gray

# Shortcut: Git Bash in repo folder
$gitBashExe = "${env:ProgramFiles}\Git\git-bash.exe"
if (Test-Path $gitBashExe) {
    New-Shortcut `
        -Path "$DesktopPath\Git Bash (Team $TeamNumber).lnk" `
        -Target $gitBashExe `
        -Arguments "--cd=`"$RepoPath`""
    Write-Host "  Created shortcut: Git Bash (Team $TeamNumber)" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# Desktop README
# -----------------------------------------------------------------------------

$readmeContent = @"
TEAM $TeamNumber - $TeamName
==========================================

YOUR CODE LIVES IN:
  $RepoPath

EVERYDAY COMMANDS (run from Git Bash in the repo folder):

  Get latest code from GitHub:
    git pull

  Save your changes:
    git add .
    git commit -m "describe what you changed"
    git push

  Run code on the SPIKE hub:
    python -m pybricksdev run ble --name <hub-name> main.py

GUI ALTERNATIVE:
  GitHub Desktop is installed for visual git operations
  (commits, pulls, pushes, branch switching) without the command line.

QUESTIONS?
  Talk to your coach, or contact Steve.

YOUR TEAM'S EMAIL:
  $TeamEmail

YOUR TEAM'S GITHUB:
  https://github.com/$GitHubUser/spike_basecode

CHAPTER UPSTREAM (where updates come from):
  $UpstreamUrl
"@

Set-Content -Path "$DesktopPath\README - Team $TeamNumber.txt" -Value $readmeContent -Encoding UTF8

Write-Host "  Desktop shortcuts and README created." -ForegroundColor Green
Write-Host ""

# =============================================================================
# DONE
# =============================================================================

Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host " Setup complete for Team $TeamNumber" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "REMAINING MANUAL STEPS:" -ForegroundColor Yellow
Write-Host "  1. Open Chrome, sign in with $TeamEmail"
Write-Host "  2. Set Chrome as default browser (Settings > Apps > Default apps)"
Write-Host "  3. Open Git Bash, run: git clone $ForkUrl `"$RepoPath`""
Write-Host "     (You'll be prompted to authenticate with GitHub via browser)"
Write-Host "  4. Add upstream remote:"
Write-Host "     cd `"$RepoPath`""
Write-Host "     git remote add upstream $UpstreamUrl"
Write-Host "  5. Sign in to GitHub Desktop with the team's GitHub account"
Write-Host "  6. Pin shortcuts to taskbar: right-click each desktop shortcut"
Write-Host "     and choose `"Pin to taskbar`""
Write-Host "  7. Verify: open the repo in VS Code via the desktop shortcut,"
Write-Host "     run a test commit/push, and connect to a SPIKE hub."
Write-Host ""
Write-Host "If anything went wrong, the script is safe to re-run." -ForegroundColor Gray
Write-Host ""