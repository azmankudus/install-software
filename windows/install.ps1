# ============================================================================
#  Windows Software Installation Script
#  Run as: Administrator PowerShell
# ============================================================================

Param(
    [switch]$All,
    [switch]$Sys,
    [switch]$Browser,
    [switch]$Comm,
    [switch]$Dev,
    [switch]$DB,
    [switch]$Cloud,
    [switch]$Net,
    [switch]$Media,
    [switch]$Prod,
    [switch]$Game,
    [switch]$ScoopInstall
)

# ── Logging ────────────────────────────────────────────────────────────────
$LogFile = Join-Path $HOME "install-software.log"
Start-Transcript -Path $LogFile -Append

if ($All) { 
    $Sys = $Browser = $Comm = $Dev = $DB = $Cloud = $Net = $Media = $Prod = $Game = $ScoopInstall = $true 
} elseif (-not ($Sys -or $Browser -or $Comm -or $Dev -or $DB -or $Cloud -or $Net -or $Media -or $Prod -or $Game -or $ScoopInstall)) {
    Write-Host "No categories selected. Use -All or specific flags (e.g., -Dev -Browser). Use -? for help." -ForegroundColor Yellow
    Stop-Transcript; exit
}

Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Windows Software Installer" -ForegroundColor Cyan
Write-Host "  Log: $LogFile" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ── Helpers ────────────────────────────────────────────────────────────────
function Section($msg) { Write-Host "`n▸ $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "  ✔ $msg" -ForegroundColor Green }
function ErrorMsg($msg) { Write-Host "  ✖ $msg" -ForegroundColor Red }

$ErrorActionPreference = "Stop"
trap { ErrorMsg "Step failed: $_"; Stop-Transcript; exit }

# ── Winget Helper ──────────────────────────────────────────────────────────
function Install-Winget {
    param([string[]]$Ids)
    foreach ($id in $Ids) {
        Write-Host "  Installing $id ..." -ForegroundColor DarkGray
        winget install --id $id --accept-package-agreements --accept-source-agreements --silent --upgrade --force 2>$null
    }
}

# ============================================================================
#  Categories
# ============================================================================

if ($Sys) {
    Section "System & Utilities"
    Install-Winget @(
        "7zip.7zip", "AutoHotkey.AutoHotkey", "CrystalDewWorld.CrystalDiskInfo",
        "FastCopy.FastCopy", "FastFetch-cli.FastFetch", "Klocman.BulkCrapUninstaller",
        "Microsoft.AppInstaller", "Microsoft.PowerShell", "Microsoft.PowerToys",
        "Microsoft.WindowsTerminal", "Piriform.CCleaner", "RealIX.HWiNFO",
        "ShareX.ShareX", "UPX.UPX", "Ventoy.Ventoy", "WinDirStat.WinDirStat"
    )
}

if ($Browser) {
    Section "Browsers"
    Install-Winget @("Google.Chrome", "Microsoft.Edge", "Mozilla.Firefox", "Vivaldi.Vivaldi", "LibreWolf.LibreWolf", "eloston.ungoogled-chromium")
}

if ($Comm) {
    Section "Communication"
    Install-Winget @("Cisco.Webex", "Discord.Discord", "Microsoft.Teams", "Mozilla.Thunderbird", "Telegram.TelegramDesktop", "Zoom.Zoom")
}

if ($Dev) {
    Section "Development"
    Install-Winget @(
        "Git.Git", "Microsoft.VisualStudioCode", "Notepad++.Notepad++", "Vim.Vim",
        "JetBrains.IntelliJIDEA.Community", "JetBrains.PyCharm.Community", "Google.AndroidStudio",
        "Microsoft.VisualStudio.2022.Community", "Oven-sh.Bun", "Rustlang.Rustup",
        "GoLang.Go", "Python.Python.3.13", "RubyInstallerTeam.RubyWithDevKit.3.4",
        "JanDeDobbeleer.OhMyPosh", "Insomnia.Insomnia", "JGraph.Draw", "KaiKramer.KeyStoreExplorer"
    )
    # Oh My Posh Profile setup
    Section "Oh My Posh Profile"
    $ompConfig = '$env:USERPROFILE/.config/oh-my-posh/default.json'
    $profileLine = "oh-my-posh init pwsh --config $ompConfig | Invoke-Expression"
    if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
    if (-not (Select-String -Path $PROFILE -Pattern "oh-my-posh" -Quiet)) { Add-Content -Path $PROFILE -Value "`n$profileLine" }
}

if ($DB) {
    Section "Database"
    Install-Winget @("dbeaver.dbeaver.community", "Oracle.MySQLWorkbench", "Oracle.MySQLShell", "PostgreSQL.pgAdmin", "MariaDB.Server", "MongoDB.Compass.Community")
}

if ($Cloud) {
    Section "Cloud & Infra"
    Install-Winget @("Kubernetes.kubectl", "Hashicorp.Terraform", "Hashicorp.Vagrant", "Cloudflare.cloudflared", "ngrok.ngrok", "Tailscale.Tailscale")
}

if ($Net) {
    Section "Networking"
    Install-Winget @("WiresharkFoundation.Wireshark", "PuTTY.PuTTY", "WinSCP.WinSCP", "Insecure.Nmap", "Bitvise.SSH.Client", "WireGuard.WireGuard")
}

if ($Media) {
    Section "Multimedia"
    Install-Winget @("OBSProject.OBSStudio", "gyan.FFmpeg", "PeterPawlowski.foobar2000", "PotPlayer.PotPlayer", "dotPDN.PaintDotNet", "XnSoft.XnViewMP")
}

if ($Prod) {
    Section "Productivity"
    Install-Winget @("Bitwarden.Bitwarden", "ente-io.auth-desktop", "TheDocumentFoundation.LibreOffice", "Transmission.Transmission", "WinMerge.WinMerge", "Adobe.Acrobat.Reader.64-bit")
}

if ($ScoopInstall) {
    Section "Scoop Setup"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }
    scoop bucket add java; scoop bucket add extras
    $scoopPkgs = "ant", "maven", "gradle", "groovy", "kotlin", "scala", "micronaut", "quarkus-cli", "springboot"
    foreach ($pkg in $scoopPkgs) { scoop install $pkg }
}

Write-Host "`n══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅  Installation complete!" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Stop-Transcript
