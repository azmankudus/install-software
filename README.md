<div align="center">

# 🖥️ Install Software

**Cross-platform software provisioning for Ubuntu & Windows workstations**

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04+-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Windows](https://img.shields.io/badge/Windows-11-0078D4?style=for-the-badge&logo=windows11&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)](LICENSE)

---

*Automated, opinionated setup scripts to go from a fresh OS install to a fully‑configured developer workstation — covering **100+ applications**, shell customisation, registry tweaks, and audio profiles.*

</div>

---

## <a id="toc"></a>📖 Table of Contents

- [📂 Repository Structure](#repo-structure)
- [🚀 Usage](#usage)
  - [Ubuntu](#ubuntu)
  - [Windows](#windows)
- [🛠️ Advanced Usage (Modularity)](#advanced)
- [📜 Logging & Recovery](#logging)
- [📋 Software List](#software-list)
- [🚀 Quick Start](#quick-start)
- [🐧 Ubuntu](#ubuntu-section)
  - [Summary](#summary)
  - [Detailed Steps](#detailed-steps)
- [🪟 Windows](#windows-section)
  - [Summary](#summary-1)
  - [Detailed Steps](#detailed-steps-1)
- [🔧 Configuration Files](#configs)

---

## <a id="repo-structure"></a>📂 Repository Structure <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

```
install-software/
├── .github/
│   └── workflows/ lint.yml      # CI/CD Script Validation
├── ubuntu/
│   ├── install-root.sh         # Modular Root packages (sudo)
│   ├── install-user.sh         # Modular User stacks (SDKMAN, etc.)
│   └── sync-configs.sh         # Apply settings from config/
├── windows/
│   ├── install.ps1             # Modular Winget + Scoop + MSYS2
│   ├── sync-configs.ps1        # Apply settings from config/
│   └── reg/                    # Registry tweaks
├── config/                     # Shared configurations
├── old/                        # Archived legacy scripts
└── README.md
```

---

## <a id="usage"></a>🚀 Usage <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

### Ubuntu
1.  **Configure Root environment**:
    ```bash
    sudo bash ubuntu/install-root.sh --all
    ```
2.  **Setup User environment**:
    ```bash
    bash ubuntu/install-user.sh --all
    ```
3.  **Sync Configurations**:
    ```bash
    bash ubuntu/sync-configs.sh
    ```

### Windows
1.  **Run Installer (Admin)**:
    ```powershell
    .\windows\install.ps1 -All
    ```
2.  **Sync Configurations**:
    ```powershell
    .\windows\sync-configs.ps1
    ```

---

## <a id="advanced"></a>🛠️ Advanced Usage (Modularity) <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

The scripts now support category-based installation. Instead of `--all` or `-All`, you can pick specific stacks:

| Flag (Ubuntu) | Flag (Windows) | Includes |
|:---|:---|:---|
| `--dev` | `-Dev` | Git, VS Code, JDKs, Python, Rust, Go, etc. |
| `--browser` | `-Browser` | Chrome, Edge, Firefox, Vivaldi, LibreWolf |
| `--comm` | `-Comm` | Discord, Teams, Slack, Zoom, Webex |
| `--db` | `-DB` | DBeaver, MySQL, Mongo, Postgres clients |
| `--virt` | `-Virt` | Docker/Podman, VirtualBox, VMware |
| `--net` | `-Net` | Wireshark, Nmap, Putty, Tailscale |
| `--prod` | `-Prod` | LibreOffice, Bitwarden, Joplin |

---

## <a id="logging"></a>📜 Logging & Recovery <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>
All installations are logged for troubleshooting:
- **Ubuntu Root**: `/var/log/install-software-root.log`
- **Ubuntu User**: `~/.local/state/install-software-user.log`
- **Windows**: `~\install-software.log`

---

## <a id="software-list"></a>📋 Software List <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

| # | Software | Category | Description | Ubuntu | Windows |
|---:|:---|:---|:---|:---|:---|
| 1 | 7-Zip | Utilities | File archiver | ✅ bin | ✅ winget |
| 2 | Adobe Acrobat Reader | Productivity | PDF viewer | — | ✅ winget |
| 3 | Android Studio | Dev Tools | IDE for Android | — | ✅ winget |
| 4 | AngryIP Scanner | Network | IP address scanner | — | ✅ winget |
| 5 | Ansible | Dev Tools | Config management | ✅ pipx | — |
| 6 | Ant | Dev Tools | Java build tool | ✅ sdkman | ✅ scoop |
| 7 | Antigravity | Dev Tools | Auto-updater | ✅ apt | — |
| 8 | AnyDesk | Utilities | Remote desktop | — | ✅ winget |
| 9 | Apache (httpd) | Web Server | HTTP server | ✅ apt | — |
| 10 | Apache Directory Studio | Database | LDAP browser | ✅ flatpak | — |
| 11 | Apache OpenOffice | Productivity | Office suite | — | ✅ winget |
| 12 | Arduino IDE | Dev Tools | IDE for Arduino | — | ✅ winget |
| 13 | Aria2 | Utilities | CLI downloader | ✅ apt | — |
| 14 | AutoHotkey | Utilities | Automation scripting | — | ✅ winget |
| 15 | Azure CLI | Cloud | Azure management | ✅ apt | — |
| 16 | Azure Data Studio | Database | DB editor | — | ✅ winget |
| 17 | Bitvise SSH Client | Network | SSH client | — | ✅ winget |
| 18 | Bitwarden | Security | Password manager | ✅ flatpak | ✅ winget |
| 19 | BlueJ | Dev Tools | Java IDE | ✅ deb | ✅ winget |
| 20 | Bottles | Virtualisation | Wine manager | ✅ flatpak | — |
| 21 | btop | Utilities | System monitor | ✅ apt | — |
| 22 | Build Essentials | Dev Tools | C/C++ build tools | ✅ apt | — |
| 23 | BulkCrapUninstaller | Utilities | Uninstaller | — | ✅ winget |
| 24 | Bun | Dev Tools | JS runtime | ✅ script | ✅ winget |
| 25 | Burp Suite Community | Security | Web proxy | — | ✅ winget |
| 26 | Calibre | Productivity | E-book manager | — | ✅ winget |
| 27 | CCleaner | Utilities | System cleaner | — | ✅ winget |
| 28 | ChromeDriver | Dev Tools | Selenium driver | — | ✅ winget |
| 29 | Cider (Apple Music) | Multimedia | Apple Music client | ✅ apt | — |
| 30 | Cisco Packet Tracer | Network | Network sim | ✅ deb | — |
| 31 | Cloudflared | Network | Cloudflare tunnel | ✅ apt | ✅ winget |
| 32 | Conky | Utilities | System monitor | ✅ apt | — |
| 33 | CrystalDiskInfo | Utilities | HDD/SSD monitor | — | ✅ winget |
| 34 | curl | Dev Tools | CLI data transfer | — | ✅ winget |
| 35 | DBeaver Community | Database | Universal DB tool | ✅ apt | ✅ winget |
| 36 | DeadBeeF | Multimedia | Audio player | ✅ deb | — |
| 37 | Discord | Communication | Chat & VoIP | ✅ flatpak | ✅ winget |
| 38 | draw.io | Productivity | Diagramming tool | ✅ deb | ✅ winget |
| 39 | Easy Effects | Multimedia | Audio processor | ✅ apt | — |
| 40 | Eclipse JEE | Dev Tools | Java IDE | — | ✅ scoop |
| 41 | EdgeDriver | Dev Tools | Selenium driver | — | ✅ winget |
| 42 | Ente Auth | Security | 2FA manager | ✅ flatpak | ✅ winget |
| 43 | FastCopy | Utilities | Fast file copy | — | ✅ winget |
| 44 | FastFetch | Utilities | System info | — | ✅ winget |
| 45 | FFMPEG | Multimedia | Video processor | ✅ apt | ✅ winget |
| 46 | FileConverter | Utilities | File converter | — | ✅ winget |
| 47 | Firefox | Browser | Web browser | ✅ apt/ppa | ✅ winget |
| 48 | Flutter | Dev Tools | UI toolkit | — | ✅ scoop |
| 49 | foobar2000 | Multimedia | Audio player | — | ✅ winget |
| 50 | GeckoDriver | Dev Tools | Selenium driver | — | ✅ winget |
| 51 | GIMP | Multimedia | Image editor | ✅ apt | — |
| 52 | Git | Dev Tools | Version control | ✅ apt | ✅ winget |
| 53 | GitLab Runner | Dev Tools | CI/CD runner | — | ✅ winget |
| 54 | GNS3 | Network | Network sim | ✅ ppa | — |
| 55 | Golang | Dev Tools | Go language | ✅ ppa | ✅ winget |
| 56 | Google Chrome | Browser | Web browser | ✅ apt | ✅ winget |
| 57 | Gradle | Dev Tools | Build tool | ✅ sdkman | ✅ scoop |
| 58 | Groovy | Dev Tools | Scripting lang | ✅ sdkman | ✅ scoop |
| 59 | Helidon | Dev Tools | Microservices | ✅ sdkman | — |
| 60 | htop | Utilities | System monitor | ✅ apt | — |
| 61 | HWiNFO | Utilities | Hardware info | — | ✅ winget |
| 62 | HxD | Utilities | Hex editor | — | ✅ winget |
| 63 | ImgBurn | Utilities | Disc burner | — | ✅ winget |
| 64 | Inkscape | Multimedia | Vector editor | ✅ apt | — |
| 65 | Insomnia | Dev Tools | API client | ✅ deb | ✅ winget |
| 66 | IntelliJ IDEA Community | Dev Tools | Java IDE | — | ✅ winget |
| 67 | Java (Liberica JDK) | Dev Tools | Java runtime | — | ✅ winget |
| 68 | Java (Temurin JDK) | Dev Tools | Java runtime | ✅ sdkman | — |
| 69 | JMC | Dev Tools | Mission Control | ✅ sdkman | — |
| 70 | JMeter | Dev Tools | Load testing | ✅ sdkman | — |
| 71 | Joplin | Productivity | Note-taking | ✅ script | — |
| 72 | JReleaser | Dev Tools | Release manager | ✅ sdkman | — |
| 73 | KeyStore Explorer | Security | Key/cert tool | ✅ deb | ✅ winget |
| 74 | Kotlin | Dev Tools | Programming lang | ✅ sdkman | ✅ scoop |
| 75 | kubectl | Cloud | Kubernetes CLI | ✅ apt | ✅ winget |
| 76 | KVM / Libvirt / Virt-Manager | Virtualisation | Virtualization | ✅ apt | — |
| 77 | Liberica NIK | Dev Tools | Native images | — | ✅ winget |
| 78 | LibreOffice | Productivity | Office suite | ✅ apt | ✅ winget |
| 79 | LibreWolf | Browser | Privacy browser | ✅ extrepo | ✅ winget |
| 80 | Lua | Dev Tools | Scripting lang | ✅ apt | ✅ winget |
| 81 | MariaDB Client/Server | Database | SQL database | ✅ apt | ✅ winget |
| 82 | Maven | Dev Tools | Java build tool | ✅ sdkman | ✅ scoop |
| 83 | MediaInfo | Multimedia | Media info | — | ✅ winget |
| 84 | Meld | Dev Tools | Diff tool | ✅ apt | — |
| 85 | Micronaut | Dev Tools | Microservices | ✅ sdkman | ✅ scoop |
| 86 | Microsoft Edge | Browser | Web browser | ✅ apt | ✅ winget |
| 87 | Microsoft OneDrive | Productivity | Cloud storage | — | ✅ winget |
| 88 | Microsoft Teams | Communication | Chat & VoIP | ✅ apt | ✅ winget |
| 89 | MongoDB Compass + Shell | Database | NoSQL editor | — | ✅ winget |
| 90 | MSSQL Tools | Database | SQL Server tools | ✅ apt | ✅ winget |
| 91 | MSYS2 | Dev Tools | POSIX layer | — | ✅ winget |
| 92 | MySQL Client & Shell | Database | SQL database | ✅ apt | ✅ winget |
| 93 | MySQL Workbench | Database | SQL editor | ✅ apt/deb | ✅ winget |
| 94 | Nala | Utilities | APT frontend | ✅ apt | — |
| 95 | Neovim | Dev Tools | Text editor | ✅ ppa | — |
| 96 | NetBeans | Dev Tools | Java IDE | — | ✅ scoop |
| 97 | Net-tools | Network | Network utils | ✅ apt | — |
| 98 | Nginx | Web Server | HTTP server | ✅ apt | ✅ winget |
| 99 | Ngrok | Network | Tunneling | ✅ apt | ✅ winget |
| 100 | Nmap | Network | Security scanner | ✅ apt | ✅ winget |
| 101 | Node.js | Dev Tools | JS runtime | — | ✅ winget |
| 102 | Nomad | Cloud | Orchestrator | — | ✅ winget |
| 103 | Notepad++ | Dev Tools | Text editor | — | ✅ winget |
| 104 | Npcap | Network | Packet capture | — | ✅ winget |
| 105 | OBS Studio | Multimedia | Streaming/Rec | ✅ ppa | ✅ winget |
| 106 | Oh My Posh | Utilities | Prompt engine | ✅ script | ✅ winget |
| 107 | Ollama | AI | LLM runner | — | ✅ winget |
| 108 | OpenTofu | Cloud | Infrastructure | ✅ script | — |
| 109 | OpenWebStart | Dev Tools | JNLP runner | — | ✅ winget |
| 110 | Oracle Instant Client | Database | Database driver | ✅ tar.gz | ✅ scoop |
| 111 | Packer | Cloud | Image builder | ✅ apt | ✅ winget |
| 112 | Paint.NET | Multimedia | Image editor | — | ✅ winget |
| 113 | PDFArranger | Productivity | PDF tool | — | ✅ winget |
| 114 | Perl | Dev Tools | Programming lang | — | ✅ winget |
| 115 | pgAdmin 4 | Database | Postgres tool | ✅ apt | ✅ winget |
| 116 | Pidgin | Communication | Multi-protocol IM | ✅ apt | — |
| 117 | Podman | Virtualisation | Container engine | ✅ apt | ✅ winget |
| 118 | PostgreSQL Client | Database | SQL database | ✅ apt | ✅ winget |
| 119 | Postman | Dev Tools | API platform | — | ✅ winget |
| 120 | PotPlayer | Multimedia | Video player | — | ✅ winget |
| 121 | PowerShell | Utilities | Shell environment | — | ✅ winget |
| 122 | PowerToys | Utilities | Productivity | — | ✅ winget |
| 123 | PuTTY | Network | SSH/Telnet | — | ✅ winget |
| 124 | PyCharm Community | Dev Tools | Python IDE | — | ✅ winget |
| 125 | Python | Dev Tools | Programming lang | ✅ apt | ✅ winget |
| 126 | Quarkus | Dev Tools | Java framework | ✅ sdkman | ✅ scoop |
| 127 | Ruby | Dev Tools | Programming lang | ✅ rbenv | ✅ winget |
| 128 | Rust | Dev Tools | Programming lang | ✅ rustup | ✅ winget |
| 129 | sbt | Dev Tools | Scala build tool | ✅ sdkman | ✅ scoop |
| 130 | Scala | Dev Tools | Programming lang | ✅ sdkman | ✅ scoop |
| 131 | ShareX | Utilities | Screen capture | — | ✅ winget |
| 132 | Spring Boot | Dev Tools | Java framework | ✅ sdkman | ✅ scoop |
| 133 | SQLcl | Database | SQL CLI | — | ✅ scoop |
| 134 | Steam | Gaming | Game platform | — | ✅ winget |
| 135 | Surfshark VPN | Network | VPN client | ✅ script | ✅ winget |
| 136 | Tailscale | Network | Mesh VPN | ✅ apt | ✅ winget |
| 137 | Telegram | Communication | Messaging | ✅ flatpak | ✅ winget |
| 138 | Terraform | Cloud | Infrastructure | ✅ apt | ✅ winget |
| 139 | Thonny | Dev Tools | Python IDE | — | ✅ winget |
| 140 | Thunderbird | Communication | Email client | ✅ apt | ✅ winget |
| 141 | TigerVNC Viewer | Network | VNC client | ✅ apt | — |
| 142 | TrafficMonitor | Utilities | Network monitor | — | ✅ winget |
| 143 | Transmission | Utilities | BitTorrent | ✅ apt | ✅ winget |
| 144 | Ungoogled Chromium | Browser | Web browser | ✅ ppa | ✅ winget |
| 145 | UPX | Utilities | Executable packer | — | ✅ winget |
| 146 | USBPcap | Network | USB capture | — | ✅ winget |
| 147 | Vagrant | Cloud | Env. automation | ✅ apt | ✅ winget |
| 148 | VcXsrv | Network | X Server | — | ✅ winget |
| 149 | Ventoy | Utilities | Bootable USB | — | ✅ winget |
| 150 | Vim | Dev Tools | Text editor | — | ✅ winget |
| 151 | VirtualBox | Virtualisation | Hypervisor | ✅ apt | ✅ winget |
| 152 | Virt-Viewer | Virtualisation | VM console | — | ✅ winget |
| 153 | Visual Studio 2022 CE | Dev Tools | IDE | — | ✅ winget |
| 154 | VisualVM | Dev Tools | JVM monitor | ✅ sdkman | — |
| 155 | Vivaldi | Browser | Web browser | ✅ apt | ✅ winget |
| 156 | VLC | Multimedia | Video player | ✅ apt | — |
| 157 | VMware Workstation | Virtualisation | Hypervisor | ✅ bundle/script | — |
| 158 | VNC Viewer | Network | VNC client | — | ✅ winget |
| 159 | VS Code | Dev Tools | Text editor | ✅ apt | ✅ winget |
| 160 | Webex | Communication | Video conferencing | ✅ deb | ✅ winget |
| 161 | WinDirStat | Utilities | Disk usage | — | ✅ winget |
| 162 | WinMerge | Utilities | Diff tool | — | ✅ winget |
| 163 | WinSCP | Network | SFTP client | — | ✅ winget |
| 164 | WireGuard | Network | VPN tunnel | ✅ apt | ✅ winget |
| 165 | Wireshark | Network | Packet analyzer | ✅ ppa | ✅ winget |
| 166 | XnView MP | Multimedia | Image viewer | — | ✅ winget |
| 167 | yq | Dev Tools | YAML processor | ✅ bin | — |
| 168 | ZapZap (WhatsApp) | Communication | WhatsApp client | ✅ flatpak | — |
| 169 | Zoom | Communication | Video conferencing | ✅ deb | ✅ winget |

---

## <a id="quick-start"></a>🚀 Quick Start <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

### Ubuntu

```bash
# Step 1 — Root (installs system packages, repos, browsers, services)
sudo bash ubuntu/install-root.sh

# Step 2 — User (SDKMAN, JDKs, Rust, Ruby, Bun, fonts, aria2, …)
bash ubuntu/install-user.sh
```

### Windows

```powershell
# Run as Administrator in PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
.\windows\install.ps1
```

---

<br>

# <a id="ubuntu-section"></a>🐧 Ubuntu <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

## Summary

The Ubuntu setup is split into **two scripts** to properly separate root‑level system changes from user‑level environment configuration.

| Script | Privilege | What It Does |
|:---|:---|:---|
| `install-root.sh` | 🔴 **root** | Disables Snap, enables Flatpak, adds APT repos with signed keys, installs system packages, configures Oh My Posh system-wide |
| `install-user.sh` | 🟢 **user** | Installs SDKMAN + JDKs, Rust, Ruby, Bun, fonts, Aria2 service, Oracle client, Ansible, Joplin |

---

## Detailed Steps

### 🔴 `install-root.sh` — Root / Admin

<details>
<summary><b>1 · Disable Snap</b> — <code>🔴 root</code></summary>

Removes all snap packages, stops/disables/masks the snapd service, purges the snap daemon, and pins it to never reinstall.

```bash
snap remove firefox gtk-common-themes gnome-3-38-2004 ...
systemctl stop snapd && systemctl disable snapd && systemctl mask snapd
apt purge snapd -y && apt-mark hold snapd
```
</details>

<details>
<summary><b>2 · Flatpak + Flathub</b> — <code>🔴 root</code></summary>

Installs Flatpak and adds the Flathub remote repository.

```bash
apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
</details>

<details>
<summary><b>3 · Nala</b> — <code>🔴 root</code></summary>

Installs Nala (a prettier `apt` frontend) and aliases `apt` → `nala` for root.

```bash
apt install -y nala
echo "alias apt='nala'" >> /root/.bash_aliases
```
</details>

<details>
<summary><b>4 · Web Browsers</b> — <code>🔴 root</code></summary>

Installs the following browsers via signed APT repos and PPAs:

| Browser | Source |
|:---|:---|
| Vivaldi | Official APT repo |
| Google Chrome | Official APT repo |
| Microsoft Edge | Microsoft APT repo |
| Ungoogled Chromium | `ppa:xtradeb/apps` |
| Firefox | `ppa:mozillateam/ppa` |
| LibreWolf | `extrepo` |

Each repo's GPG key is stored in `/etc/apt/keyrings/`.
</details>

<details>
<summary><b>5 · Communication Apps</b> — <code>🔴 root</code></summary>

| App | Method |
|:---|:---|
| Teams for Linux | APT repo |
| Pidgin | `apt install` |
| Telegram | Flatpak |
| ZapZap (WhatsApp) | Flatpak |
| Discord | Flatpak |
| Webex | `.deb` download |
| Zoom | `.deb` download |
</details>

<details>
<summary><b>6 · Virtualisation & Containers</b> — <code>🔴 root</code></summary>

| Software | Notes |
|:---|:---|
| VirtualBox 7.2 | + Extension Pack; adds user to `vboxusers` group |
| VMware Workstation | Downloaded as `.bundle` |
| KVM / Libvirt / Virt-Manager | Full QEMU-KVM stack; adds user to `kvm`, `libvirt` groups |
| Podman | + podman-remote, podman-docker, podman-compose |
</details>

<details>
<summary><b>7 · Development Tools</b> — <code>🔴 root</code></summary>

| Software | Notes |
|:---|:---|
| Git | `apt install` |
| VS Code | Microsoft APT repo (source list removed post-install to avoid conflicts) |
| Neovim | `ppa:neovim-ppa/stable` |
| Build Essentials | GCC, make, headers, SSL/YAML/zlib/FFI dev libs |
| Golang | `ppa:longsleep/golang-backports` |
| Python 3 + pipx | System Python with pipx for isolated CLI tools |
| Lua 5.4 | `apt install` |
| BlueJ | Latest `.deb` from GitHub releases |
| Insomnia | Latest `.deb` from GitHub releases |
| draw.io | Latest `.deb` from GitHub releases |
| KeyStore Explorer | Latest `.deb` from GitHub releases |
| Antigravity | Official APT repo |
</details>

<details>
<summary><b>8 · Database Clients</b> — <code>🔴 root</code></summary>

| Client | Source |
|:---|:---|
| PostgreSQL Client | Official PostgreSQL APT repo |
| MariaDB Client | MariaDB 12 rolling APT repo |
| MySQL Client & Shell | MySQL APT config `.deb` |
| MySQL Workbench | Latest version from MySQL downloads |
| MSSQL Tools 18 | Microsoft APT repo |
| pgAdmin 4 | pgAdmin APT repo |
| DBeaver Community | DBeaver APT repo |
| Apache Directory Studio | Flatpak |
</details>

<details>
<summary><b>9 · Cloud & Infrastructure</b> — <code>🔴 root</code></summary>

| Tool | Source |
|:---|:---|
| kubectl | Kubernetes APT repo (auto-detects latest stable minor) |
| Azure CLI | Microsoft APT repo |
| Terraform | HashiCorp APT repo |
| Packer | HashiCorp APT repo |
| Vagrant | HashiCorp APT repo |
| OpenTofu | Official installer script |
</details>

<details>
<summary><b>10 · Networking & Tunnels</b> — <code>🔴 root</code></summary>

| Tool | Notes |
|:---|:---|
| Nginx | Official mainline repo (installed but **disabled**) |
| Apache | `apt install` (installed but **disabled**) |
| Cloudflared | Cloudflare APT repo |
| Ngrok | Ngrok APT repo |
| Tailscale | Tailscale APT repo (installed but **disabled**) |
| WireGuard | `apt install` |
| Surfshark VPN | Official installer script |
</details>

<details>
<summary><b>11 · Network Utilities</b> — <code>🔴 root</code></summary>

| Tool | Notes |
|:---|:---|
| Nmap | `apt install` |
| Net-tools | `apt install` |
| Wireshark | PPA for latest; adds user to `wireshark` group |
| GNS3 | PPA; adds user to `ubridge` group |
| Cisco Packet Tracer | `.deb` download |
</details>

<details>
<summary><b>12 · Multimedia</b> — <code>🔴 root</code></summary>

| Software | Method |
|:---|:---|
| FFMPEG | `apt install` |
| VLC | `apt install` |
| OBS Studio | PPA for latest |
| GIMP | `apt install` |
| Inkscape | `apt install` |
| Easy Effects | `apt install` |
| Cider (Apple Music) | APT repo |
| DeadBeeF | `.deb` download |
</details>

<details>
<summary><b>13 · Productivity & Utilities</b> — <code>🔴 root</code></summary>

| Software | Method |
|:---|:---|
| LibreOffice | `apt install` |
| Transmission | `apt install` |
| Meld | `apt install` |
| Conky | `apt install` |
| htop / btop | `apt install` |
| TigerVNC Viewer | `apt install` |
| Aria2 | `apt install` |
| Bitwarden | Flatpak |
| Ente Auth | Flatpak |
| Bottles | Flatpak |
</details>

<details>
<summary><b>14 · Oh My Posh</b> — <code>🔴 root</code></summary>

Installs Oh My Posh to `/usr/local/bin` and configures it system-wide in `/etc/bash.bashrc`. Uses the custom theme from `config/oh-my-posh.json`.

```bash
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
cp config/oh-my-posh.json /etc/oh-my-posh.json
```
</details>

---

### 🟢 `install-user.sh` — Normal User

<details>
<summary><b>1 · Git Configuration</b> — <code>🟢 user</code></summary>

Generates an Ed25519 SSH key for GitHub and configures global Git identity.

```bash
ssh-keygen -t ed25519 -C "github@${USER}@${HOSTNAME}" -f ~/.ssh/id_ed25519_github
git config --global user.name  'Azman Kudus'
git config --global user.email 'aa.azmankudus@outlook.my'
git config --global core.sshCommand "ssh -i ~/.ssh/id_ed25519_github"
```
</details>

<details>
<summary><b>2 · Vim Configuration</b> — <code>🟢 user</code></summary>

Disables mouse mode in Vim:

```bash
echo 'set mouse-=a' > ~/.vimrc
```
</details>

<details>
<summary><b>3 · SDKMAN + JDK/Tools</b> — <code>🟢 user</code></summary>

Installs SDKMAN, then uses it to install:

| Category | Packages |
|:---|:---|
| **JDKs** | Temurin 8, 11, 17, 21, 25 |
| **Build tools** | Gradle, Maven, Ant |
| **Frameworks** | Micronaut, Quarkus, Spring Boot, Helidon, GCN |
| **Languages** | Scala, Groovy, Kotlin |
| **Utilities** | sbt, mcs, JMC, JMeter, JReleaser, VisualVM |

Also creates a `javahome-scan.sh` helper that symlinks JDK versions to `~/.jdk/`.
</details>

<details>
<summary><b>4 · Fonts</b> — <code>🟢 user</code></summary>

Downloads and installs **AnonymousPro Nerd Font** (mono) for terminal use.
</details>

<details>
<summary><b>5 · Aria2 (User Service)</b> — <code>🟢 user</code></summary>

Configures Aria2 with RPC support and installs it as a systemd **user** service with linger enabled for persistence.
</details>

<details>
<summary><b>6 · Rust</b> — <code>🟢 user</code></summary>

Installs Rust via `rustup` with default toolchain.
</details>

<details>
<summary><b>7 · Ruby (rbenv)</b> — <code>🟢 user</code></summary>

Installs rbenv + ruby-build, then installs Ruby 3.3, 3.4, and 4.0 versions.
</details>

<details>
<summary><b>8 · Bun</b> — <code>🟢 user</code></summary>

Installs Bun (JavaScript runtime).
</details>

<details>
<summary><b>9 · 7-Zip</b> — <code>🟢 user</code></summary>

Downloads the latest 7-Zip Linux CLI to `~/.local/share/7zip` and symlinks into `~/.local/bin`.
</details>

<details>
<summary><b>10 · yq</b> — <code>🟢 user</code></summary>

Downloads `yq` (YAML processor) to `~/.local/bin`.
</details>

<details>
<summary><b>11 · Ansible</b> — <code>🟢 user</code></summary>

Installs Ansible via `pipx` for isolated dependency management.
</details>

<details>
<summary><b>12 · Oracle Instant Client</b> — <code>🟢 user</code></summary>

Downloads all Oracle Instant Client packages (basic, sqlplus, tools, SDK, JDBC, ODBC) and extracts to `~/.local/share/instantclient`. Configures `ORACLE_HOME`, `TNS_ADMIN`, and `PATH` in `~/.bashrc`.
</details>

<details>
<summary><b>13 · Joplin</b> — <code>🟢 user</code></summary>

Installs the Joplin note-taking app via the official installer script.
</details>

---

<br>

# <a id="windows-section"></a>🪟 Windows <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

## Summary

The Windows setup uses a **single PowerShell script** that leverages three package managers and optional registry tweaks.

| Component | Privilege | What It Does |
|:---|:---|:---|
| Winget packages | 🔴 **Admin** | Installs 130+ packages via `winget install` |
| Scoop packages | 🟢 **User** | Installs JVM ecosystem tools via Scoop |
| MSYS2 packages | 🟢 **User** | GCC, CLI tools, Oh My Posh inside MSYS2 |
| Registry tweaks | 🔴 **Admin** | Security, UX, and developer convenience `.reg` files |
| Profile relocation | 🔴 **Admin** | Optional sysprep XML to move `Users` to `D:\` |

---

## Detailed Steps

### 🔴 Winget Packages — Admin

<details>
<summary><b>1 · System & Utilities</b> — <code>🔴 admin</code></summary>

Installs core system utilities and runtimes:

7-Zip, AutoHotkey, CrystalDiskInfo, FastCopy, FastFetch, BulkCrapUninstaller, PowerShell, PowerToys, Windows Terminal, CCleaner, HWiNFO, ShareX, UPX, Ventoy, WinDirStat, TrafficMonitor, Visual C++ Redistributables, UI.Xaml, VCLibs.
</details>

<details>
<summary><b>2 · Browsers</b> — <code>🔴 admin</code></summary>

Google Chrome, Microsoft Edge, Ungoogled Chromium, Vivaldi, LibreWolf, Firefox.
</details>

<details>
<summary><b>3 · Communication</b> — <code>🔴 admin</code></summary>

Microsoft Teams, Cisco Webex, Discord, Telegram, Thunderbird, Zoom.
</details>

<details>
<summary><b>4 · Development</b> — <code>🔴 admin</code></summary>

| Category | Packages |
|:---|:---|
| **JDKs** | Liberica JDK 8, 11, 17, 21, 24; Liberica NIK 23 |
| **Languages** | Python 3.13, GoLang, Lua, Ruby 3.4, Rust, Perl, Bun, Node.js |
| **Editors/IDEs** | VS Code, IntelliJ IDEA CE, PyCharm CE, Visual Studio 2022 CE, Notepad++, Vim, Thonny, Android Studio |
| **Utilities** | Git, GitLab Runner, curl, draw.io, Insomnia, KeyStore Explorer, Oh My Posh, OpenWebStart, WebDeploy, MSYS2 |
</details>

<details>
<summary><b>5 · Database</b> — <code>🔴 admin</code></summary>

DBeaver CE, MariaDB Server, Azure Data Studio, SQL Server CLR Types, MS ODBC SQL 17, MongoDB Compass + Shell, MySQL Shell + Workbench, pgAdmin, PostgreSQL 17.
</details>

<details>
<summary><b>6 · Virtualisation & AI</b> — <code>🔴 admin</code></summary>

VirtualBox, Podman, Virt-Viewer, Ollama.
</details>

<details>
<summary><b>7 · Cloud & Infrastructure</b> — <code>🔴 admin</code></summary>

Cloudflared, Nomad, Packer, Terraform, Vagrant, kubectl, Ngrok, Surfshark, Tailscale.
</details>

<details>
<summary><b>8 · Networking</b> — <code>🔴 admin</code></summary>

Bitvise SSH, ChromeDriver, USBPcap, Nmap, Npcap, VcXsrv, EdgeDriver, GeckoDriver, Nginx, PuTTY, VNC Viewer, WinSCP, WireGuard, Wireshark.
</details>

<details>
<summary><b>9 · Multimedia</b> — <code>🔴 admin</code></summary>

FileConverter, PotPlayer, FFmpeg, MediaInfo, HxD, OBS Studio, foobar2000, Paint.NET, XnView MP.
</details>

<details>
<summary><b>10 · Productivity</b> — <code>🔴 admin</code></summary>

Adobe Acrobat Reader, AngryIP Scanner, AnyDesk, Apache OpenOffice, Arduino IDE, Bitwarden, Calibre, Ente Auth, ImgBurn, OneDrive, PDFArranger, Postman, Burp Suite CE, LibreOffice, Transmission, WinMerge, Steam.
</details>

---

### 🟢 Scoop Packages — User

<details>
<summary><b>11 · JVM Ecosystem (Scoop)</b> — <code>🟢 user</code></summary>

Installs via Scoop (user-level, no admin required):

Ant, Eclipse JEE, Flutter, Gradle, Groovy, Kotlin, Kotlin Native, Maven, Micronaut, NetBeans, Oracle Instant Client + SqlPlus, Quarkus CLI, sbt, Scala, Spring Boot, SQLcl.
</details>

---

### 🟢 MSYS2 Packages — User

<details>
<summary><b>12 · MSYS2 CLI Tools</b> — <code>🟢 user</code></summary>

Run manually inside the MSYS2 terminal:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S tar gzip bzip2 xz zip unzip wget curl gnu-netcat inetutils vim git openssh openssl
pacman -S mingw-w64-ucrt-x86_64-oh-my-posh
```
</details>

---

### 🔴 Registry Tweaks — Admin

<details>
<summary><b>13 · Registry Modifications</b> — <code>🔴 admin</code></summary>

Double-click to apply (or run `regedit /s <file>`). Undo files are in `windows/reg/undo/`.

| Tweak | File |
|:---|:---|
| Add Shift+Right-click "Open command window here" | `add-shift-open-command-window-here.reg` |
| Disable auto-restart after Windows Update | `disable-auto-restart-after-windows-update.reg` |
| Remove 260-char path limit | `disable-path-260-character-limit.reg` |
| Classic context menu (disable "Show more options") | `disable-show-more-options-context-menu.reg` |
| UAC prompt requires password | `enable-admin-prompt-password.reg` |
| Require Ctrl+Alt+Del on lock screen | `enable-lock-screen-ctrl-alt-del.reg` |
| Enable TCP/IP Router | `enable-tcpiprouter.reg` |

**Custom context-menu entries** (in `windows/reg/custom/`):
- Open (non-Shift) command window here
- Enable/Disable Windows Photo Viewer
- Open with Notepad++
</details>

---

### 🔴 Profile Relocation — Admin

<details>
<summary><b>14 · Relocate User Profiles to D:\</b> — <code>🔴 admin</code></summary>

Use during Windows setup via Sysprep/Unattend:

```powershell
sysprep /oobe /reboot /unattend:config\relocate.xml
```

This moves the default `Users` folder from `C:\Users` to `D:\Users`.
</details>

---

## <a id="configs"></a>🔧 Configuration Files <a href="#toc"><img src="https://api.iconify.design/material-symbols:arrow-upward.svg?color=gray" width="20" align="right"></a>

| File | Description |
|:---|:---|
| `config/oh-my-posh.json` | Custom Oh My Posh prompt theme (datetime, hostname, user, shell, exec-time, exit-code, git, path) |
| `config/Microsoft.PowerShell_profile.ps1` | PowerShell profile to initialise Oh My Posh |
| `config/relocate.xml` | Sysprep unattend XML to relocate user profiles to `D:\Users` |
| `config/easyeffects/hp.json` | EasyEffects headphone profile (Gate → Compressor → Multiband Compressor → EQ → Limiter) |
| `config/easyeffects/spk.json` | EasyEffects speaker profile (same chain, speaker-tuned EQ) |
| `config/foo_openlyrics-v1.8.fb2k-component` | foobar2000 OpenLyrics component |
| `config/foo_vis_spectrum_analyzer.fb2k-component` | foobar2000 Spectrum Analyzer component |

---

<br>

---

---

<div align="center">

**Total: 169 software entries** · **Ubuntu: 95** · **Windows: 120** · **Both: 46**

*Made with ☕ by Azman Kudus*

</div>