#!/usr/bin/env bash
# ============================================================================
#  Ubuntu Software Installation Script — Root
#  Run as: sudo bash install-root.sh
#  Tested on: Ubuntu 24.04+ (Noble)
# ============================================================================
set -euo pipefail

source /etc/os-release
ENDUSER="${SUDO_USER:-${USER}}"

echo "══════════════════════════════════════════════════════════════"
echo "  Ubuntu Root Installer"
echo "  Codename : ${UBUNTU_CODENAME}"
echo "  End-user : ${ENDUSER}"
echo "══════════════════════════════════════════════════════════════"

# ── Helpers ────────────────────────────────────────────────────────────────
section()  { echo -e "\n\033[1;36m▸ $1\033[0m"; }
success()  { echo -e "\033[1;32m  ✔ $1\033[0m"; }
install_deb_url() {
  local url="$1"
  local tmp
  tmp=$(mktemp --suffix=.deb)
  curl -fsSL -o "${tmp}" "${url}"
  dpkg -i "${tmp}" || true
  apt install -y -f
  rm -f "${tmp}"
}

# ── Keyrings Directory ─────────────────────────────────────────────────────
mkdir -p -m 755 /etc/apt/keyrings

# ============================================================================
#  1 · DISABLE SNAP
# ============================================================================
section "Removing Snap"
snap remove firefox gtk-common-themes gnome-3-38-2004 \
  snapd-desktop-integration snap-store core20 bare snapd 2>/dev/null || true
systemctl stop snapd 2>/dev/null || true
systemctl disable snapd 2>/dev/null || true
systemctl mask snapd 2>/dev/null || true
apt purge snapd -y 2>/dev/null || true
apt-mark hold snapd 2>/dev/null || true

rm -rf /root/snap /snap /var/snap /var/lib/snapd

cat <<'EOF' > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

cat <<'EOF' > /etc/apt/preferences.d/ubuntu.pref
Package: *
Pin: release o=Ubuntu
Pin-Priority: 100
EOF
success "Snap disabled"

# ============================================================================
#  2 · FLATPAK
# ============================================================================
section "Flatpak"
apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
success "Flatpak + Flathub configured"

# ============================================================================
#  3 · NALA (apt wrapper)
# ============================================================================
section "Nala"
apt install -y nala
grep -qxF "alias apt='nala'" /root/.bash_aliases 2>/dev/null || \
  echo "alias apt='nala'" >> /root/.bash_aliases
success "Nala installed"

# ============================================================================
#  4 · WEB BROWSERS
# ============================================================================
section "Vivaldi"
curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub \
  | gpg --yes --dearmor -o /etc/apt/keyrings/vivaldi.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/stable/deb/ stable main" \
  > /etc/apt/sources.list.d/vivaldi.list
apt update && apt install -y vivaldi-stable
success "Vivaldi installed"

section "Google Chrome"
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
  | gpg --yes --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
  > /etc/apt/sources.list.d/google-chrome.list
apt update && apt install -y google-chrome-stable
success "Google Chrome installed"

section "Microsoft Edge"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/microsoft-edge.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge/ stable main" \
  > /etc/apt/sources.list.d/microsoft-edge.list
apt update && apt install -y microsoft-edge-stable
success "Microsoft Edge installed"

section "Ungoogled Chromium (PPA)"
add-apt-repository -y ppa:xtradeb/apps
apt update && apt install -y ungoogled-chromium
success "Ungoogled Chromium installed"

section "Mozilla Firefox & Thunderbird (PPA)"
add-apt-repository -y ppa:mozillateam/ppa
apt update && apt install -y firefox thunderbird
success "Firefox & Thunderbird installed"

section "LibreWolf"
apt install -y extrepo
extrepo enable librewolf
apt update && apt install -y librewolf
success "LibreWolf installed"

# ============================================================================
#  5 · COMMUNICATION
# ============================================================================
section "Teams for Linux"
curl -fsSL https://repo.teamsforlinux.de/teams-for-linux.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/teamsforlinux.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/teamsforlinux.gpg] https://repo.teamsforlinux.de/debian/ stable main" \
  > /etc/apt/sources.list.d/teamsforlinux.list
apt update && apt install -y teams-for-linux
success "Teams for Linux installed"

section "Pidgin"
apt install -y pidgin
success "Pidgin installed"

section "Communication — Flatpaks"
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.rtosta.zapzap
flatpak install -y flathub com.discordapp.Discord
success "Telegram, ZapZap (WhatsApp), Discord installed"

section "Webex"
install_deb_url "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
success "Webex installed"

section "Zoom"
install_deb_url "https://zoom.us/client/latest/zoom_amd64.deb"
success "Zoom installed"

# ============================================================================
#  6 · VIRTUALISATION & CONTAINERS
# ============================================================================
section "VirtualBox"
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/virtualbox.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian ${UBUNTU_CODENAME} contrib" \
  > /etc/apt/sources.list.d/virtualbox.list
apt update && apt install -y virtualbox-7.2
VBOX_VER=$(VBoxManage --version | cut -d'r' -f1)
curl -fsSLO "https://download.virtualbox.org/virtualbox/${VBOX_VER}/Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
VBoxManage extpack install --replace "Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
rm -f "Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
usermod -aG vboxusers "${ENDUSER}"
success "VirtualBox + Extension Pack installed"

section "VMware Workstation"
wget --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:141.0) Gecko/20100101 Firefox/141.0" \
  -O vmware-workstation.bundle \
  "https://files02.tchspt.com/down/VMware-Workstation-Full-25H2-24995812.x86_64.bundle"
chmod +x vmware-workstation.bundle
./vmware-workstation.bundle
rm -f vmware-workstation.bundle
success "VMware Workstation installed"

section "KVM / Libvirt / Virt-Manager"
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients \
  bridge-utils virt-manager virt-viewer
usermod -aG kvm,libvirt "${ENDUSER}"
success "KVM / Libvirt stack installed"

section "Podman"
apt install -y podman podman-remote podman-docker podman-compose
success "Podman installed"

# ============================================================================
#  7 · DEVELOPMENT TOOLS
# ============================================================================
section "Git"
apt install -y git
success "Git installed"

section "VS Code"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/vscode.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" \
  > /etc/apt/sources.list.d/vscode.list
apt update && apt install -y code
rm -f /etc/apt/sources.list.d/vscode.list
success "VS Code installed"

section "Neovim (PPA)"
add-apt-repository -y ppa:neovim-ppa/stable
apt update && apt install -y neovim
success "Neovim installed"

section "Build Essentials"
apt install -y build-essential linux-headers-"$(uname -r)" \
  autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev \
  patch libreadline6-dev libncurses5-dev libgdbm6 libgdbm-dev libdb-dev
success "Build essentials installed"

section "Golang (PPA)"
add-apt-repository -y ppa:longsleep/golang-backports
apt update && apt install -y golang-go
success "Golang installed"

section "Python"
apt install -y python3 python3-pip pipx
pipx ensurepath
pipx completions
success "Python + pipx installed"

section "Lua"
apt install -y lua5.4
success "Lua installed"

section "BlueJ"
BLUEJ_URL=$(curl -fsSL https://api.github.com/repos/k-pet-group/BlueJ-Greenfoot/releases/latest \
  | jq -r '.assets[] | select(.name | test("BlueJ-linux-x64-.*.deb")) | .browser_download_url')
install_deb_url "${BLUEJ_URL}"
success "BlueJ installed"

section "Insomnia"
INSOMNIA_URL=$(curl -fsSL https://api.github.com/repos/Kong/insomnia/releases/latest \
  | jq -r '.assets[] | select(.name | test("Insomnia.Core-.*.deb")) | .browser_download_url')
install_deb_url "${INSOMNIA_URL}"
success "Insomnia installed"

section "draw.io"
DRAWIO_URL=$(curl -fsSL https://api.github.com/repos/jgraph/drawio-desktop/releases/latest \
  | jq -r '.assets[] | select(.name | test("drawio-amd64-.*.deb")) | .browser_download_url')
install_deb_url "${DRAWIO_URL}"
success "draw.io installed"

section "KeyStore Explorer"
KSE_URL=$(curl -fsSL https://api.github.com/repos/kaikramer/keystore-explorer/releases/latest \
  | jq -r '.assets[] | select(.name | test("kse_.*_all\\.deb")) | .browser_download_url')
install_deb_url "${KSE_URL}"
success "KeyStore Explorer installed"

section "Antigravity"
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg \
  | gpg --yes --dearmor -o /etc/apt/keyrings/antigravity.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/antigravity.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
  > /etc/apt/sources.list.d/antigravity.list
apt update && apt install -y antigravity
success "Antigravity installed"

# ============================================================================
#  8 · DATABASE CLIENTS
# ============================================================================
section "PostgreSQL Client"
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/postgresql.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt ${UBUNTU_CODENAME}-pgdg main" \
  > /etc/apt/sources.list.d/postgresql.list
apt update && apt install -y postgresql-client
success "PostgreSQL Client installed"

section "MariaDB Client"
curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp \
  | gpg --yes --dearmor -o /etc/apt/keyrings/mariadb.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mariadb.gpg] https://mirror.sg.mariadb.org/repo/12.rolling/ubuntu ${UBUNTU_CODENAME} main" \
  > /etc/apt/sources.list.d/mariadb.list
apt update && apt install -y mariadb-client
success "MariaDB Client installed"

section "MySQL Client & Shell"
install_deb_url "https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb"
apt update && apt install -y mysql-client mysql-shell
success "MySQL Client & Shell installed"

section "MySQL Workbench"
MYSQL_WB_VER=$(curl -sSL https://dev.mysql.com/downloads/workbench 2>/dev/null \
  | grep h1 | awk '{print $3}' | tail -1)
install_deb_url "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${MYSQL_WB_VER}-1ubuntu24.04_amd64.deb"
success "MySQL Workbench installed"

section "Microsoft SQL Tools"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/mssql.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mssql.gpg] https://packages.microsoft.com/repos/microsoft-ubuntu-${UBUNTU_CODENAME}-prod/ ${UBUNTU_CODENAME} main" \
  > /etc/apt/sources.list.d/mssql.list
apt update && ACCEPT_EULA=Y apt install -y mssql-tools18 unixodbc-dev
success "MSSQL Tools installed"

section "pgAdmin 4"
curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub \
  | gpg --yes --dearmor -o /etc/apt/keyrings/pgadmin.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pgadmin.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/${UBUNTU_CODENAME} pgadmin4 main" \
  > /etc/apt/sources.list.d/pgadmin.list
apt update && apt install -y pgadmin4-desktop
success "pgAdmin 4 installed"

section "DBeaver Community"
curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key \
  | gpg --yes --dearmor -o /etc/apt/keyrings/dbeaver.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" \
  > /etc/apt/sources.list.d/dbeaver.list
apt update && apt install -y dbeaver-ce
success "DBeaver Community installed"

section "Directory Studio — Flatpak"
flatpak install -y flathub org.apache.directory.studio
success "Apache Directory Studio installed"

# ============================================================================
#  9 · CLOUD & INFRASTRUCTURE
# ============================================================================
section "Kubernetes (kubectl)"
BASE_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt | sed -E 's/.[0-9]+$//')
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/Release.key" \
  | gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/ /" \
  > /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubectl
success "kubectl installed"

section "Azure CLI"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/azure.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/azure.gpg] https://packages.microsoft.com/repos/azure-cli ${UBUNTU_CODENAME} main" \
  > /etc/apt/sources.list.d/azure.list
apt update && apt install -y azure-cli
success "Azure CLI installed"

section "HashiCorp (Terraform, Packer, Vagrant)"
curl -fsSL https://apt.releases.hashicorp.com/gpg \
  | gpg --yes --dearmor -o /etc/apt/keyrings/hashicorp.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" \
  > /etc/apt/sources.list.d/hashicorp.list
apt update && apt install -y terraform packer vagrant
success "Terraform, Packer, Vagrant installed"

section "OpenTofu"
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method deb
success "OpenTofu installed"

# ============================================================================
# 10 · NETWORKING & TUNNELS
# ============================================================================
section "Nginx"
curl -fsSL https://nginx.org/keys/nginx_signing.key \
  | gpg --yes --dearmor -o /etc/apt/keyrings/nginx.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nginx.gpg] https://nginx.org/packages/mainline/ubuntu ${UBUNTU_CODENAME} nginx" \
  > /etc/apt/sources.list.d/nginx.list
apt update && apt install -y nginx
systemctl disable --now nginx
success "Nginx installed (disabled)"

section "Apache"
apt install -y apache2
systemctl disable --now apache2
success "Apache installed (disabled)"

section "Cloudflared"
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | gpg --yes --dearmor -o /etc/apt/keyrings/cloudflare.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/cloudflared any main" \
  > /etc/apt/sources.list.d/cloudflare.list
apt update && apt install -y cloudflared
success "Cloudflared installed"

section "Ngrok"
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | gpg --yes --dearmor -o /etc/apt/keyrings/ngrok.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com bookworm main" \
  > /etc/apt/sources.list.d/ngrok.list
apt update && apt install -y ngrok
success "Ngrok installed"

section "Tailscale"
curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg" \
  | gpg --yes --dearmor -o /etc/apt/keyrings/tailscale.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu ${UBUNTU_CODENAME} main" \
  > /etc/apt/sources.list.d/tailscale.list
apt update && apt install -y tailscale
systemctl disable --now tailscaled
success "Tailscale installed (disabled)"

section "WireGuard"
apt install -y wireguard
success "WireGuard installed"

section "Surfshark VPN"
curl -fsSL -o /tmp/surfshark-install.sh https://downloads.surfshark.com/linux/debian-install.sh
sh /tmp/surfshark-install.sh
rm -f /tmp/surfshark-install.sh
success "Surfshark installed"

# ============================================================================
# 11 · NETWORK UTILITIES
# ============================================================================
section "Network Tools"
apt install -y nmap net-tools wireshark
groupadd wireshark 2>/dev/null || true
usermod -aG wireshark "${ENDUSER}"
success "Nmap, Net-tools, Wireshark installed"

section "Wireshark (PPA — latest)"
add-apt-repository -y ppa:wireshark-dev/stable
apt update && apt install -y wireshark
success "Wireshark (latest) installed"

section "GNS3"
add-apt-repository -y ppa:gns3/ppa
apt update && apt install -y gns3-gui gns3-server
groupadd ubridge 2>/dev/null || true
usermod -aG ubridge "${ENDUSER}"
success "GNS3 installed"

section "Cisco Packet Tracer"
install_deb_url "https://archive.org/download/cisco-packet-tracer-900-win-64bit/CiscoPacketTracer_900_Ubuntu.deb"
success "Cisco Packet Tracer installed"

# ============================================================================
# 12 · MULTIMEDIA
# ============================================================================
section "Multimedia Tools"
apt install -y ffmpeg vlc obs-studio gimp inkscape
success "FFMPEG, VLC, OBS Studio, GIMP, Inkscape installed"

section "OBS Studio (PPA — latest)"
add-apt-repository -y ppa:obsproject/obs-studio
apt update && apt install -y obs-studio
success "OBS Studio (latest) installed"

section "Easy Effects"
apt install -y easyeffects
success "Easy Effects installed"

section "Cider (Apple Music)"
curl -fsSL https://repo.cider.sh/APT-GPG-KEY \
  | gpg --yes --dearmor -o /etc/apt/keyrings/cider.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cider.gpg] https://repo.cider.sh/apt stable main" \
  > /etc/apt/sources.list.d/cider.list
apt update && apt install -y cider
success "Cider installed"

section "DeadBeeF"
install_deb_url "https://sf-west-interserver-2.dl.sourceforge.net/project/deadbeef/travis/linux/1.10.0/deadbeef-static_1.10.0-1_amd64.deb?viasf=1"
success "DeadBeeF installed"

# ============================================================================
# 13 · PRODUCTIVITY & UTILITIES
# ============================================================================
section "Productivity"
apt install -y libreoffice transmission meld conky-all htop btop \
  tigervnc-viewer aria2
success "LibreOffice, Transmission, Meld, Conky, htop, btop, TigerVNC, Aria2 installed"

section "Flatpaks — Productivity"
flatpak install -y flathub com.bitwarden.desktop
flatpak install -y flathub io.ente.auth
flatpak install -y flathub com.usebottles.bottles
success "Bitwarden, Ente Auth, Bottles installed"

# ============================================================================
# 14 · OH MY POSH (system-wide)
# ============================================================================
section "Oh My Posh"
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
rm -rf /root/.cache/oh-my-posh/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "${SCRIPT_DIR}/../config/oh-my-posh.json" ]; then
  cp -p "${SCRIPT_DIR}/../config/oh-my-posh.json" /etc/oh-my-posh.json
  chmod 644 /etc/oh-my-posh.json
  chown root:root /etc/oh-my-posh.json
fi

grep -q 'oh-my-posh init bash' /etc/bash.bashrc 2>/dev/null || \
cat <<'EOF' >> /etc/bash.bashrc

# Oh My Posh
eval "$(oh-my-posh init bash --config /etc/oh-my-posh.json)"
EOF
success "Oh My Posh installed (system-wide)"

# ============================================================================
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  ✅  Root installation complete!"
echo "  ➡  Now run install-user.sh as ${ENDUSER}"
echo "══════════════════════════════════════════════════════════════"
