# ============================================================================
#  Config Sync Script — Windows
#  Automatically links files from config/ to their system locations.
#  Run as: Administrator PowerShell
# ============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigDir = Join-Path (Split-Path -Parent $ScriptDir) "config"

function Section($msg) { Write-Host "`n▸ $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "  ✔ $msg" -ForegroundColor Green }

Section "Syncing Configurations"

# Oh My Posh
$ompPath = Join-Path $HOME ".config/oh-my-posh"
if (-not (Test-Path $ompPath)) { New-Item -ItemType Directory -Path $ompPath -Force | Out-Null }
New-Item -ItemType SymbolicLink -Path (Join-Path $ompPath "default.json") -Target (Join-Path $ConfigDir "oh-my-posh.json") -Force | Out-Null
Success "Oh My Posh config linked"

# PowerShell Profile
$profileSrc = Join-Path $ConfigDir "Microsoft.PowerShell_profile.ps1"
if (Test-Path $profileSrc) {
    Copy-Item -Path $profileSrc -Destination $PROFILE -Force
    Success "PowerShell profile updated"
}

Success "Sync complete!"
