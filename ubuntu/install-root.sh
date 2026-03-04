#!/usr/bin/env bash
# ============================================================================
#  Ubuntu Software Installation Script — Root
#  Run as: sudo bash install-root.sh [FLAGS]
#  Tested on: Ubuntu 24.04+ (Noble)
# ============================================================================
set -euo pipefail

# ── Logging ────────────────────────────────────────────────────────────────
LOG_FILE="/var/log/install-software-root.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

source /etc/os-release
ENDUSER="${SUDO_USER:-${USER}}"

# ── Categories ─────────────────────────────────────────────────────────────
INSTALL_ALL=true
CAT_DEV=false; CAT_BROWSER=false; CAT_COMM=false; CAT_VIRT=false
CAT_DB=false; CAT_CLOUD=false; CAT_NET=false; CAT_MEDIA=false; CAT_PROD=false

show_help() {
  echo "Usage: sudo bash install-root.sh [options]"
  echo "Options:"
  echo "  --all         Install everything (default)"
  echo "  --dev         Development tools"
  echo "  --browser     Web browsers"
  echo "  --comm        Communication tools"
  echo "  --virt        Virtualization & Containers"
  echo "  --db          Database clients"
  echo "  --cloud       Cloud & Infrastructure"
  echo "  --net         Networking & Tunnels"
  echo "  --media       Multimedia tools"
  echo "  --prod        Productivity & Utilities"
  exit 0
}

if [[ $# -gt 0 ]]; then
  INSTALL_ALL=false
  for arg in "$@"; do
    case $arg in
      --all)     INSTALL_ALL=true ;;
      --dev)     CAT_DEV=true ;;
      --browser) CAT_BROWSER=true ;;
      --comm)    CAT_COMM=true ;;
      --virt)    CAT_VIRT=true ;;
      --db)      CAT_DB=true ;;
      --cloud)   CAT_CLOUD=true ;;
      --net)     CAT_NET=true ;;
      --media)   CAT_MEDIA=true ;;
      --prod)    CAT_PROD=true ;;
      --help)    show_help ;;
    esac
  done
fi

if [ "$INSTALL_ALL" = true ]; then
  CAT_DEV=true; CAT_BROWSER=true; CAT_COMM=true; CAT_VIRT=true
  CAT_DB=true; CAT_CLOUD=true; CAT_NET=true; CAT_MEDIA=true; CAT_PROD=true
fi

echo "══════════════════════════════════════════════════════════════"
echo "  Ubuntu Root Installer"
echo "  Codename : ${UBUNTU_CODENAME}"
echo "  End-user : ${ENDUSER}"
echo "  Log      : ${LOG_FILE}"
echo "══════════════════════════════════════════════════════════════"

# ── Helpers ────────────────────────────────────────────────────────────────
section()  { echo -e "\n\033[1;36m▸ $1\033[0m"; }
success()  { echo -e "\033[1;32m  ✔ $1\033[0m"; }
error()    { echo -e "\033[1;31m  ✖ $1\033[0m"; }
trap 'error "Step failed at line $LINENO. Check ${LOG_FILE}"' ERR

install_deb_url() {
  local url="$1"
  local tmp
  tmp=$(mktemp --suffix=.deb)
  curl -fsSL -o "${tmp}" "${url}"
  dpkg -i "${tmp}" || true
  apt install -y -f
  rm -f "${tmp}"
}

# ── Core Setup (Always) ────────────────────────────────────────────────────
section "Core System Setup"
mkdir -p -m 755 /etc/apt/keyrings
apt update
apt install -y curl gpg jq software-properties-common apt-transport-https

# Disable Snap
section "Removing Snap"
snap remove firefox gtk-common-themes gnome-3-38-2004 \
  snapd-desktop-integration snap-store core20 bare snapd 2>/dev/null || true
systemctl stop snapd 2>/dev/null || true
systemctl disable snapd 2>/dev/null || true
systemctl mask snapd 2>/dev/null || true
apt purge -y snapd 2>/dev/null || true
apt-mark hold snapd 2>/dev/null || true
rm -rf /root/snap /snap /var/snap /var/lib/snapd
cat <<'EOF' > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# Nala & Flatpak
apt install -y nala flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ============================================================================
#  1 · WEB BROWSERS
# ============================================================================
if [ "$CAT_BROWSER" = true ]; then
  section "Browsers"
  # Vivaldi
  curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --yes --dearmor -o /etc/apt/keyrings/vivaldi.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list
  # Google Chrome
  curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --yes --dearmor -o /etc/apt/keyrings/google-chrome.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
  # Edge
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/microsoft-edge.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge/ stable main" > /etc/apt/sources.list.d/microsoft-edge.list
  
  add-apt-repository -y ppa:xtradeb/apps # Ungoogled Chromium
  add-apt-repository -y ppa:mozillateam/ppa # Firefox
  apt update
  apt install -y vivaldi-stable google-chrome-stable microsoft-edge-stable ungoogled-chromium firefox thunderbird
  
  apt install -y extrepo && extrepo enable librewolf && apt update && apt install -y librewolf
  success "Browsers installed"
fi

# ============================================================================
#  2 · COMMUNICATION
# ============================================================================
if [ "$CAT_COMM" = true ]; then
  section "Communication"
  curl -fsSL https://repo.teamsforlinux.de/teams-for-linux.asc | gpg --yes --dearmor -o /etc/apt/keyrings/teamsforlinux.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/teamsforlinux.gpg] https://repo.teamsforlinux.de/debian/ stable main" > /etc/apt/sources.list.d/teamsforlinux.list
  apt update && apt install -y teams-for-linux pidgin
  
  flatpak install -y flathub org.telegram.desktop com.rtosta.zapzap com.discordapp.Discord
  install_deb_url "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
  install_deb_url "https://zoom.us/client/latest/zoom_amd64.deb"
  success "Communication tools installed"
fi

# ============================================================================
#  3 · VIRTUALISATION
# ============================================================================
if [ "$CAT_VIRT" = true ]; then
  section "Virtualization"
  # VirtualBox
  curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --yes --dearmor -o /etc/apt/keyrings/virtualbox.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian ${UBUNTU_CODENAME} contrib" > /etc/apt/sources.list.d/virtualbox.list
  apt update && apt install -y virtualbox-7.2
  VBOX_VER=$(VBoxManage --version | cut -d'r' -f1)
  curl -fsSLO "https://download.virtualbox.org/virtualbox/${VBOX_VER}/Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
  VBoxManage extpack install --replace "Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
  rm -f "Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
  usermod -aG vboxusers "${ENDUSER}"

  # VMware
  wget --user-agent="Mozilla/5.0" -O vmware-workstation.bundle "https://files02.tchspt.com/down/VMware-Workstation-Full-25H2-24995812.x86_64.bundle"
  chmod +x vmware-workstation.bundle && ./vmware-workstation.bundle --console --required && rm -f vmware-workstation.bundle

  # KVM & Podman
  apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virt-viewer podman podman-docker podman-compose
  usermod -aG kvm,libvirt "${ENDUSER}"
  success "Virtualization stack installed"
fi

# ============================================================================
#  4 · DEVELOPMENT TOOLS
# ============================================================================
if [ "$CAT_DEV" = true ]; then
  section "Dev Tools"
  # VS Code
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/vscode.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
  
  add-apt-repository -y ppa:neovim-ppa/stable
  add-apt-repository -y ppa:longsleep/golang-backports
  apt update && apt install -y code git neovim golang-go python3 python3-pip pipx build-essential lua5.4
  rm -f /etc/apt/sources.list.d/vscode.list

  # GitHub Apps
  install_deb_url "$(curl -fsSL https://api.github.com/repos/k-pet-group/BlueJ-Greenfoot/releases/latest | jq -r '.assets[] | select(.name | test("BlueJ-linux-x64-.*.deb")) | .browser_download_url')"
  install_deb_url "$(curl -fsSL https://api.github.com/repos/Kong/insomnia/releases/latest | jq -r '.assets[] | select(.name | test("Insomnia.Core-.*.deb")) | .browser_download_url')"
  install_deb_url "$(curl -fsSL https://api.github.com/repos/kaikramer/keystore-explorer/releases/latest | jq -r '.assets[] | select(.name | test("kse_.*_all\\.deb")) | .browser_download_url')"

  # Antigravity
  curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --yes --dearmor -o /etc/apt/keyrings/antigravity.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/antigravity.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list
  apt update && apt install -y antigravity
  success "Dev tools installed"
fi

# ============================================================================
#  5 · DATABASE CLIENTS
# ============================================================================
if [ "$CAT_DB" = true ]; then
  section "Database Clients"
  # Postgres
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --yes --dearmor -o /etc/apt/keyrings/postgresql.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt ${UBUNTU_CODENAME}-pgdg main" > /etc/apt/sources.list.d/postgresql.list
  # MariaDB
  curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp | gpg --yes --dearmor -o /etc/apt/keyrings/mariadb.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mariadb.gpg] https://mirror.sg.mariadb.org/repo/12.rolling/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/mariadb.list
  # pgAdmin
  curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --yes --dearmor -o /etc/apt/keyrings/pgadmin.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pgadmin.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/${UBUNTU_CODENAME} pgadmin4 main" > /etc/apt/sources.list.d/pgadmin.list
  # DBeaver
  curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | gpg --yes --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list

  apt update && apt install -y postgresql-client mariadb-client pgadmin4-desktop dbeaver-ce
  install_deb_url "https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb"
  apt update && apt install -y mysql-client mysql-shell
  
  MYSQL_WB_VER=$(curl -sSL https://dev.mysql.com/downloads/workbench 2>/dev/null | grep h1 | awk '{print $3}' | tail -1)
  install_deb_url "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${MYSQL_WB_VER}-1ubuntu24.04_amd64.deb"
  
  flatpak install -y flathub org.apache.directory.studio
  success "Database clients installed"
fi

# ============================================================================
#  6 · CLOUD & INFRASTRUCTURE
# ============================================================================
if [ "$CAT_CLOUD" = true ]; then
  section "Cloud"
  BASE_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt | sed -E 's/.[0-9]+$//')
  curl -fsSL "https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/Release.key" | gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list
  
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/azure-mssql.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/azure-mssql.gpg] https://packages.microsoft.com/repos/azure-cli ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/azure.list
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/azure-mssql.gpg] https://packages.microsoft.com/repos/microsoft-ubuntu-${UBUNTU_CODENAME}-prod/ ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/mssql.list

  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --yes --dearmor -o /etc/apt/keyrings/hashicorp.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list

  apt update && apt install -y kubectl azure-cli terraform packer vagrant
  ACCEPT_EULA=Y apt install -y mssql-tools18 unixodbc-dev
  curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method deb
  success "Cloud tools installed"
fi

# ============================================================================
#  7 · NETWORKING
# ============================================================================
if [ "$CAT_NET" = true ]; then
  section "Networking"
  curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --yes --dearmor -o /etc/apt/keyrings/nginx.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nginx.gpg] https://nginx.org/packages/mainline/ubuntu ${UBUNTU_CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list
  
  curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --yes --dearmor -o /etc/apt/keyrings/cloudflare.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/cloudflared any main" > /etc/apt/sources.list.d/cloudflare.list

  curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | gpg --yes --dearmor -o /etc/apt/keyrings/ngrok.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com bookworm main" > /etc/apt/sources.list.d/ngrok.list

  curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg" | gpg --yes --dearmor -o /etc/apt/keyrings/tailscale.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/tailscale.list

  add-apt-repository -y ppa:wireshark-dev/stable
  add-apt-repository -y ppa:gns3/ppa
  apt update && apt install -y nginx apache2 cloudflared ngrok tailscale wireguard nmap net-tools wireshark gns-gui gns3-server
  systemctl disable --now nginx apache2 tailscaled 2>/dev/null || true
  
  curl -fsSL https://downloads.surfshark.com/linux/debian-install.sh | bash
  install_deb_url "https://archive.org/download/cisco-packet-tracer-900-win-64bit/CiscoPacketTracer_900_Ubuntu.deb"
  
  usermod -aG wireshark,ubridge "${ENDUSER}"
  success "Networking tools installed"
fi

# ============================================================================
#  8 · MULTIMEDIA
# ============================================================================
if [ "$CAT_MEDIA" = true ]; then
  section "Multimedia"
  add-apt-repository -y ppa:obsproject/obs-studio
  apt update && apt install -y ffmpeg vlc obs-studio gimp inkscape easyeffects
  
  curl -fsSL https://repo.cider.sh/APT-GPG-KEY | gpg --yes --dearmor -o /etc/apt/keyrings/cider.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cider.gpg] https://repo.cider.sh/apt stable main" > /etc/apt/sources.list.d/cider.list
  apt update && apt install -y cider
  
  install_deb_url "https://sf-west-interserver-2.dl.sourceforge.net/project/deadbeef/travis/linux/1.10.0/deadbeef-static_1.10.0-1_amd64.deb?viasf=1"
  success "Multimedia installed"
fi

# ============================================================================
#  9 · PRODUCTIVITY
# ============================================================================
if [ "$CAT_PROD" = true ]; then
  section "Productivity"
  apt install -y libreoffice transmission meld conky-all htop btop tigervnc-viewer aria2
  flatpak install -y flathub com.bitwarden.desktop io.ente.auth com.usebottles.bottles
  
  # Oh My Posh
  curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  if [ -f "${SCRIPT_DIR}/../config/oh-my-posh.json" ]; then
    cp -p "${SCRIPT_DIR}/../config/oh-my-posh.json" /etc/oh-my-posh.json
    chmod 644 /etc/oh-my-posh.json
    grep -q 'oh-my-posh init bash' /etc/bash.bashrc || echo 'eval "$(oh-my-posh init bash --config /etc/oh-my-posh.json)"' >> /etc/bash.bashrc
  fi
  success "Productivity tools installed"
fi

# ============================================================================
echo -e "\n\033[1;32m══════════════════════════════════════════════════════════════"
echo "  ✅  Root installation complete!"
echo "  Log: ${LOG_FILE}"
echo -e "══════════════════════════════════════════════════════════════\033[0m"
