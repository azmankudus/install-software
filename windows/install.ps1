# ============================================================================
#  Windows Software Installation Script
#  Run as: Administrator PowerShell
# ============================================================================

Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Windows Software Installer" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ── Helpers ────────────────────────────────────────────────────────────────
function Section($msg) { Write-Host "`n▸ $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "  ✔ $msg" -ForegroundColor Green }

# ============================================================================
#  1 · WINGET PACKAGES (Admin)
# ============================================================================
Section "Installing winget packages"

$wingetPackages = @(
    # ── System & Utilities ──
    "7zip.7zip"
    "AutoHotkey.AutoHotkey"
    "CrystalDewWorld.CrystalDiskInfo"
    "FastCopy.FastCopy"
    "FastFetch-cli.FastFetch"
    "Klocman.BulkCrapUninstaller"
    "Microsoft.AppInstaller"
    "Microsoft.PowerShell"
    "Microsoft.PowerToys"
    "Microsoft.UI.Xaml.2.8"
    "Microsoft.VCLibs.Desktop.14"
    "Microsoft.VCRedist.2008.x64"
    "Microsoft.VCRedist.2008.x86"
    "Microsoft.VCRedist.2013.x86"
    "Microsoft.VCRedist.2015+.x64"
    "Microsoft.VCRedist.2015+.x86"
    "Microsoft.WindowsTerminal"
    "Piriform.CCleaner"
    "RealIX.HWiNFO"
    "ShareX.ShareX"
    "UPX.UPX"
    "Ventoy.Ventoy"
    "WinDirStat.WinDirStat"
    "ZhongYang219.TrafficMonitor.Lite"
    # ── Browsers ──
    "eloston.ungoogled-chromium"
    "Google.Chrome"
    "LibreWolf.LibreWolf"
    "Microsoft.Edge"
    "Mozilla.Firefox"
    "Vivaldi.Vivaldi"
    # ── Communication ──
    "Cisco.Webex"
    "Discord.Discord"
    "Microsoft.Teams"
    "Mozilla.Thunderbird"
    "Telegram.TelegramDesktop"
    "Zoom.Zoom"
    # ── Development ──
    "BellSoft.LibericaJDK.8"
    "BellSoft.LibericaJDK.11"
    "BellSoft.LibericaJDK.17"
    "BellSoft.LibericaJDK.21"
    "BellSoft.LibericaJDK.24"
    "BellSoft.LibericaNIK.23.JDK21"
    "curl.curl"
    "DevCom.Lua"
    "Git.Git"
    "GitLab.Runner"
    "GoLang.Go"
    "Google.AndroidStudio"
    "Insomnia.Insomnia"
    "JanDeDobbeleer.OhMyPosh"
    "JetBrains.IntelliJIDEA.Community"
    "JetBrains.PyCharm.Community"
    "JGraph.Draw"
    "KaiKramer.KeyStoreExplorer"
    "Karakun.OpenWebStart"
    "Microsoft.VisualStudio.2022.Community"
    "Microsoft.VisualStudioCode"
    "Microsoft.WebDeploy"
    "MSYS2.MSYS2"
    "Notepad++.Notepad++"
    "OpenJS.NodeJS"
    "Oven-sh.Bun"
    "Python.Launcher"
    "Python.Python.3.13"
    "RubyInstallerTeam.RubyWithDevKit.3.4"
    "Rustlang.Rustup"
    "StrawberryPerl.StrawberryPerl"
    "Vim.Vim"
    # ── Database ──
    "dbeaver.dbeaver.community"
    "MariaDB.Server"
    "Microsoft.AzureDataStudio"
    "Microsoft.CLRTypesSQLServer.2019"
    "Microsoft.MSODBCSQL.17"
    "MongoDB.Compass.Community"
    "MongoDB.Shell"
    "Oracle.MySQLShell"
    "Oracle.MySQLWorkbench"
    "PostgreSQL.pgAdmin"
    "PostgreSQL.PostgreSQL.17"
    # ── Virtualisation ──
    "Oracle.VirtualBox"
    "Ollama.Ollama"
    "RedHat.Podman"
    "RedHat.VirtViewer"
    # ── Cloud & Infra ──
    "Cloudflare.cloudflared"
    "Hashicorp.Nomad"
    "Hashicorp.Packer"
    "Hashicorp.Terraform"
    "Hashicorp.Vagrant"
    "Kubernetes.kubectl"
    "ngrok.ngrok"
    "Surfshark.Surfshark"
    "Tailscale.Tailscale"
    # ── Networking ──
    "Bitvise.SSH.Client"
    "Chromium.ChromeDriver"
    "desowin.usbpcap"
    "Insecure.Nmap"
    "Insecure.Npcap"
    "MarHA.VcXsrv"
    "Microsoft.EdgeDriver"
    "Mozilla.GeckoDriver"
    "NginxInc.Nginx"
    "PuTTY.PuTTY"
    "RealVNC.VNCViewer"
    "WinSCP.WinSCP"
    "WireGuard.WireGuard"
    "WiresharkFoundation.Wireshark"
    # ── Multimedia ──
    "AdrienAllard.FileConverter"
    "Daum.PotPlayer"
    "gyan.FFmpeg"
    "MediaArea.MediaInfo.GUI"
    "MHNexus.HxD"
    "OBSProject.OBSStudio"
    "PeterPawlowski.foobar2000"
    "dotPDN.PaintDotNet"
    "XnSoft.XnViewMP"
    # ── Productivity ──
    "Adobe.Acrobat.Reader.64-bit"
    "AivarAnnamaa.Thonny"
    "AngryZiber.AngryIPScanner"
    "AnyDesk.AnyDesk"
    "Apache.OpenOffice"
    "ArduinoSA.IDE.Stable"
    "Bitwarden.Bitwarden"
    "Calibre.Calibre"
    "ente-io.auth-desktop"
    "LightningUK.ImgBurn"
    "Microsoft.OneDrive"
    "PDFArranger.PDFArranger"
    "Postman.Postman"
    "PortSwigger.BurpSuite.Community"
    "TheDocumentFoundation.LibreOffice"
    "Transmission.Transmission"
    "WinMerge.WinMerge"
    # ── Gaming ──
    "Valve.Steam"
)

foreach ($pkg in $wingetPackages) {
    Write-Host "  Installing $pkg ..." -ForegroundColor DarkGray
    winget install --id $pkg --accept-package-agreements --accept-source-agreements --silent 2>$null
}
Success "Winget packages installed"

# ============================================================================
#  2 · SCOOP (User-level package manager)
# ============================================================================
Section "Scoop Setup"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

scoop bucket add java
scoop bucket add extras

$scoopPackages = @(
    "ant"
    "eclipse-jee"
    "flutter"
    "gradle"
    "groovy"
    "kotlin"
    "kotlin-native"
    "maven"
    "micronaut"
    "netbeans"
    "oracle-instant-client"
    "oracle-instant-client-sqlplus"
    "quarkus-cli"
    "sbt"
    "scala"
    "springboot"
    "sqlcl"
)

foreach ($pkg in $scoopPackages) {
    Write-Host "  Installing $pkg ..." -ForegroundColor DarkGray
    scoop install $pkg 2>$null
}
Success "Scoop packages installed"

# ============================================================================
#  3 · MSYS2 PACKAGES
# ============================================================================
Section "MSYS2 Packages"
Write-Host "  Run the following inside MSYS2 terminal:" -ForegroundColor Yellow
Write-Host '    pacman -S mingw-w64-ucrt-x86_64-gcc' -ForegroundColor Gray
Write-Host '    pacman -S tar gzip bzip2 xz zip unzip wget curl gnu-netcat inetutils vim git openssh openssl' -ForegroundColor Gray
Write-Host '    pacman -S mingw-w64-ucrt-x86_64-oh-my-posh' -ForegroundColor Gray

# ============================================================================
#  4 · OH MY POSH (PowerShell profile)
# ============================================================================
Section "Oh My Posh — PowerShell Profile"
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

$ompConfig = '$env:USERPROFILE/.config/oh-my-posh/default.json'
$profileLine = "oh-my-posh init pwsh --config $ompConfig | Invoke-Expression"

if (-not (Test-Path $PROFILE) -or -not (Select-String -Path $PROFILE -Pattern "oh-my-posh" -Quiet)) {
    Add-Content -Path $PROFILE -Value $profileLine
}
Success "PowerShell profile configured for Oh My Posh"

# ============================================================================
#  5 · REGISTRY TWEAKS
# ============================================================================
Section "Registry Tweaks"
Write-Host "  Apply .reg files from the 'windows/reg/' folder as needed:" -ForegroundColor Yellow
Write-Host "    • add-shift-open-command-window-here.reg" -ForegroundColor Gray
Write-Host "    • disable-auto-restart-after-windows-update.reg" -ForegroundColor Gray
Write-Host "    • disable-path-260-character-limit.reg" -ForegroundColor Gray
Write-Host "    • disable-show-more-options-context-menu.reg" -ForegroundColor Gray
Write-Host "    • enable-admin-prompt-password.reg" -ForegroundColor Gray
Write-Host "    • enable-lock-screen-ctrl-alt-del.reg" -ForegroundColor Gray
Write-Host "    • enable-tcpiprouter.reg" -ForegroundColor Gray

# ============================================================================
#  6 · USER PROFILE RELOCATION (optional)
# ============================================================================
Section "User Profile Relocation"
Write-Host "  Use 'config/relocate.xml' with sysprep to relocate profiles to D:\Users" -ForegroundColor Yellow
Write-Host '    sysprep /oobe /reboot /unattend:config\relocate.xml' -ForegroundColor Gray

# ============================================================================
Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅  Windows installation complete!" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
