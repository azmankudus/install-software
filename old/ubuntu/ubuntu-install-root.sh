source /etc/os-release
ENDUSER=U00240012

# Disable snap

snap remove firefox
snap remove gtk-common-themes
snap remove gnome-3-38-2004
snap remove snapd-desktop-integration
snap remove snap-store
snap remove core20
snap remove bare
snap remove snapd
systemctl stop snapd
systemctl disable snapd
systemctl mask snapd
apt purge snapd -y
apt-mark hold snapd

rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd

cat << EOF > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# Set ubuntu repo as low priority
cat << EOF > /etc/apt/preferences.d/ubuntu.pref
Package: *
Pin: release o=Ubuntu
Pin-Priority: 100
EOF



# Keyrings folder
mkdir -p -m 755 /etc/apt/keyrings



# Flatpak
apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Nala
apt install -y nala
cat <<EOF >> /root/.bash_aliases

alias apt='nala'
EOF
source /root/.bashrc



# Vivaldi
curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --yes --dearmor -o /etc/apt/keyrings/vivaldi.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list
apt update
apt install -y vivaldi-stable

# Chrome
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --yes --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update
apt install -y google-chrome-stable

# Edge
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/microsoft-edge.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge/ stable main" > /etc/apt/sources.list.d/microsoft-edge.list
apt update
apt install -y microsoft-edge-stable

# Teams
curl -fsSL https://repo.teamsforlinux.de/teams-for-linux.asc | gpg --yes --dearmor -o /etc/apt/keyrings/teamsforlinux.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/teamsforlinux.gpg] https://repo.teamsforlinux.de/debian/ stable main" > /etc/apt/sources.list.d/teamsforlinux.list
apt update
apt install -y teams-for-linux

# VirtualBox
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --yes --dearmor -o /etc/apt/keyrings/virtualbox.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian ${UBUNTU_CODENAME} contrib" > /etc/apt/sources.list.d/virtualbox.list
apt update
apt install -y virtualbox-7.2
CURRENT_VERSION=$(VBoxManage --version | cut -d'r' -f1)
curl -fsSLO https://download.virtualbox.org/virtualbox/${CURRENT_VERSION}/Oracle_VirtualBox_Extension_Pack-${CURRENT_VERSION}.vbox-extpack
VBoxManage extpack install Oracle_VirtualBox_Extension_Pack-${CURRENT_VERSION}.vbox-extpack
rm -f Oracle_VirtualBox_Extension_Pack-${CURRENT_VERSION}.vbox-extpack
usermod -aG vboxusers ${ENDUSER}

# Kubernetes
BASE_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt | sed -E 's/.[0-9]+$//')
curl -fsSL https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/Release.key | gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/${BASE_VERSION}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubectl

# VS Code
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/vscode.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code
rm -f /etc/apt/sources.list.d/vscode.list

# PostgreSQL
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --yes --dearmor -o /etc/apt/keyrings/postgresql.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt ${UBUNTU_CODENAME}-pgdg main" > /etc/apt/sources.list.d/postgresql.list
apt update
apt install -y postgresql-client

# MariaDB
curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp | gpg --yes --dearmor -o /etc/apt/keyrings/mariadb.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mariadb.gpg] https://mirror.sg.mariadb.org/repo/12.rolling/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/mariadb.list
apt update
apt install -y mariadb-client

# Microsoft SQL
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/mssql.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mssql.gpg] https://packages.microsoft.com/repos/microsoft-ubuntu-${UBUNTU_CODENAME}-prod/ ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/mssql.list
apt update
ACCEPT_EULA=Y apt install -y mssql-tools18 unixodbc-dev

# Azure
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor -o /etc/apt/keyrings/azure.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/azure.gpg] https://packages.microsoft.com/repos/azure-cli ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/azure.list
apt update
apt install -y azure-cli

# pgAdmin
curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --yes --dearmor -o /etc/apt/keyrings/pgadmin.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pgadmin.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/${UBUNTU_CODENAME} pgadmin4 main" > /etc/apt/sources.list.d/pgadmin.list
apt update
apt install -y pgadmin4-desktop

# DBeaver
curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | gpg --yes --dearmor -o /etc/apt/keyrings/dbeaver.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce / " > /etc/apt/sources.list.d/dbeaver.list
apt update
apt install -y dbeaver-ce

# Hashicorp
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --yes --dearmor -o /etc/apt/keyrings/hashicorp.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list
apt update
apt install -y terraform
apt install -y packer
apt install -y vagrant

# Cider
curl -fsSL https://repo.cider.sh/APT-GPG-KEY | gpg --yes --dearmor -o /etc/apt/keyrings/cider.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cider.gpg] https://repo.cider.sh/apt stable main" > /etc/apt/sources.list.d/cider.list
apt update
apt install -y cider

# Antigravity
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --yes --dearmor -o /etc/apt/keyrings/antigravity.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/antigravity.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list
apt update
apt install -y antigravity

# Nginx
curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --yes --dearmor -o /etc/apt/keyrings/nginx.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nginx.gpg] https://nginx.org/packages/mainline/ubuntu ${UBUNTU_CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list
apt update
apt install -y nginx
systemctl disable --now nginx

# Cloudflare
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --yes --dearmor -o /etc/apt/keyrings/cloudflare.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/cloudflared any main" > /etc/apt/sources.list.d/cloudflare.list
apt update
apt install -y cloudflared

# Ngrok
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | gpg --yes --dearmor -o /etc/apt/keyrings/ngrok.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com bookworm main" > /etc/apt/sources.list.d/ngrok.list
apt update
apt install -y ngrok

# Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | gpg --yes --dearmor -o /etc/apt/keyrings/tailscale.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/tailscale.list
apt update
apt install -y tailscale
systemctl disable --now tailscaled



# Golang
add-apt-repository -y ppa:longsleep/golang-backports
apt update
apt install -y golang-go

# Wireshark
add-apt-repository -y ppa:wireshark-dev/stable
apt update
apt install -y wireshark

groupadd wireshark
usermod -aG wireshark ${ENDUSER}

# GNS3
add-apt-repository -y ppa:gns3/ppa
apt update
apt install -y gns3-gui gns3-server
groupadd ubridge
usermod -aG ubridge ${ENDUSER}

# OBS Studio
add-apt-repository -y ppa:obsproject/obs-studio
apt update
apt install -y obs-studio

# Chromium
add-apt-repository -y ppa:xtradeb/apps
apt update
apt install -y ungoogled-chromium

Mozilla
add-apt-repository -y ppa:mozillateam/ppa
apt update
apt install -y firefox
apt install -y thunderbird

# Neovim
add-apt-repository -y ppa:neovim-ppa/stable
apt update
apt install -y neovim

# LibreWolf
apt install -y extrepo
extrepo enable librewolf
apt update
apt install -y librewolf



# Pidgin
apt install -y pidgin

# Transmission BT
apt install -y transmission

# FFMPEG
apt install -y ffmpeg

# GIMP
apt install -y gimp

# Inkscape
apt install -y inkscape

# Git
apt install -y git

# Easy Effects
apt install -y easyeffects

# Aria2
apt install -y aria2

# Lua
apt install -y lua5.4

# Python
apt install -y python3 python3-pip pipx
pipx ensurepath
pipx completions

# Build essentials
apt install -y build-essential linux-headers-$(uname -r) autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev patch libreadline6-dev libncurses5-dev libgdbm6 libgdbm-dev libdb-dev

# Libvirt
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virt-viewer
usermod -aG kvm,libvirt ${ENDUSER}

# Podman
apt install -y podman podman-remote podman-docker podman-compose

# TigerVNC Viewer
apt install -y tigervnc-viewer

# Nmap
apt install -y nmap

# Net Tools
apt install -y net-tools

# Wireguard
apt install -y wireguard

# Apache
apt install -y apache2
systemctl disable --now apache2

# LibreOffice
apt install -y libreoffice

# VLC
apt install -y vlc

# Conky
apt install -y conky-all

# Top
apt install -y htop btop

# Net
apt install -y net-tools nmap

# Meld
apt install -y meld



# Bitwarden
flatpak install -y flathub com.bitwarden.desktop

# Ente Auth
flatpak install -y flathub io.ente.auth

# Telegram
flatpak install -y flathub org.telegram.desktop

# Whatsapp
flatpak install -y flathub com.rtosta.zapzap

# Discord
flatpak install -y flathub com.discordapp.Discord

# Directory Studio
flatpak install -y flathub org.apache.directory.studio

# Bottles
flatpak install -y flathub com.usebottles.bottles



# MySQL
curl -fsSL -o app.deb 'https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb'
dpkg -i app.deb
apt install -y -f
rm -f app.deb
apt update
apt install -y mysql-client mysql-shell

# Webex
curl -fsSL -o app.deb https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# Zoom
curl -fsSL -o app.deb https://zoom.us/client/latest/zoom_amd64.deb
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# BlueJ
curl -fsSL -o app.deb $(curl -fsSL https://api.github.com/repos/k-pet-group/BlueJ-Greenfoot/releases/latest | jq -r '.assets[] | select (.name | test("BlueJ-linux-x64-.*.deb")) | .browser_download_url')
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# Insomnia
curl -fsSL -o app.deb $(curl -fsSL https://api.github.com/repos/Kong/insomnia/releases/latest | jq -r '.assets[] | select (.name | test("Insomnia.Core-.*.deb")) | .browser_download_url')
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# draw.io
curl -fsSL -o app.deb $(curl -fsSL https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | jq -r '.assets[] | select (.name | test("drawio-amd64-.*.deb")) | .browser_download_url')
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# DeadBeeF
curl -fsSL -o app.deb https://sf-west-interserver-2.dl.sourceforge.net/project/deadbeef/travis/linux/1.10.0/deadbeef-static_1.10.0-1_amd64.deb?viasf=1
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# Oh My Posh
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
rm -rf /root/.cache/oh-my-posh/
cat <<EOF >> /etc/bash.bashrc

# Oh My Posh
eval "\$(oh-my-posh init bash --config /etc/oh-my-posh.json)"
EOF
cp -p /home/<USER>/Downloads/oh-my-posh.json /etc/
chmod 644 /etc/oh-my-posh.json
chown root:root /etc/oh-my-posh.json

# VMware Workstation
wget --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:141.0) Gecko/20100101 Firefox/141.0" -O vmware-workstation.bundle https://files02.tchspt.com/down/VMware-Workstation-Full-25H2-24995812.x86_64.bundle
chmod +x vmware-workstation.bundle
./vmware-workstation.bundle
rm -f vmware-workstation.bundle

# OpenTofu
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method deb

# Packet Tracer
curl -fsSL -o app.deb https://archive.org/download/cisco-packet-tracer-900-win-64bit/CiscoPacketTracer_900_Ubuntu.deb
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# Surfshark
curl -fsSL -o surfshark-install.sh https://downloads.surfshark.com/linux/debian-install.sh
sh surfshark-install.sh
rm -f surfshark-install.sh

# MySQL Workbench
LATEST_VERSION=$(curl -sSL https://dev.mysql.com/downloads/workbench 2> /dev/null | grep h1 | awk '{print $3}' | tail -1)
curl -fsSL -o app.deb https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${LATEST_VERSION}-1ubuntu24.04_amd64.deb
dpkg -i app.deb
apt install -y -f
rm -f app.deb

# KeyStore Explorer
curl -fsSL -o app.deb $(curl -fsSL https://api.github.com/repos/kaikramer/keystore-explorer/releases/latest | jq -r '.assets[] | select (.name | test("kse_.*_all\\.deb")) | .browser_download_url')
dpkg -i app.deb
apt install -y -f
rm -f app.deb
