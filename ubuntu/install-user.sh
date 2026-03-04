#!/usr/bin/env bash
# ============================================================================
#  Ubuntu Software Installation Script — User
#  Run as: bash install-user.sh [FLAGS]       (do NOT use sudo)
#  Tested on: Ubuntu 24.04+ (Noble)
# ============================================================================
set -euo pipefail

# ── Logging ────────────────────────────────────────────────────────────────
mkdir -p "${HOME}/.local/state"
LOG_FILE="${HOME}/.local/state/install-software-user.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

# ── Categories ─────────────────────────────────────────────────────────────
INSTALL_ALL=true
CAT_DEV=false; CAT_PROD=false; CAT_UTIL=false

show_help() {
  echo "Usage: bash install-user.sh [options]"
  echo "Options:"
  echo "  --all     Install everything (default)"
  echo "  --dev     Development stacks (SDKMAN, Rust, Ruby, Bun, Ansible)"
  echo "  --prod    Productivity tools (Fonts, Aria2, Joplin)"
  echo "  --util    Utilities (7-Zip, yq, Oracle Client, Helper scripts)"
  exit 0
}

if [[ $# -gt 0 ]]; then
  INSTALL_ALL=false
  for arg in "$@"; do
    case $arg in
      --all)  INSTALL_ALL=true ;;
      --dev)  CAT_DEV=true ;;
      --prod) CAT_PROD=true ;;
      --util) CAT_UTIL=true ;;
      --help) show_help ;;
    esac
  done
fi

if [ "$INSTALL_ALL" = true ]; then
  CAT_DEV=true; CAT_PROD=true; CAT_UTIL=true
fi

echo "══════════════════════════════════════════════════════════════"
echo "  Ubuntu User Installer"
echo "  User : ${USER}"
echo "  Log  : ${LOG_FILE}"
echo "══════════════════════════════════════════════════════════════"

# ── Helpers ────────────────────────────────────────────────────────────────
section()  { echo -e "\n\033[1;36m▸ $1\033[0m"; }
success()  { echo -e "\033[1;32m  ✔ $1\033[0m"; }
error()    { echo -e "\033[1;31m  ✖ $1\033[0m"; }
trap 'error "Step failed at line $LINENO. Check ${LOG_FILE}"' ERR

# ── Core Setup (Always) ────────────────────────────────────────────────────
section "Core User Setup"
umask 0027
grep -qxF "umask 0027" "${HOME}/.bashrc" || echo "umask 0027" >> "${HOME}/.bashrc"
mkdir -p "${HOME}/scripts" "${HOME}/.local/bin"
source "${HOME}/.profile" 2>/dev/null || true

# Git Config
ssh-keygen -t ed25519 -C "github@${USER}@${HOSTNAME}" -f "${HOME}/.ssh/id_ed25519_github" -N "" 2>/dev/null || true
git config --global user.name  'Azman Kudus'
git config --global user.email 'aa.azmankudus@outlook.my'
git config --global core.sshCommand "ssh -i ${HOME}/.ssh/id_ed25519_github"
echo 'set mouse-=a' > "${HOME}/.vimrc"

# ============================================================================
#  1 · DEVELOPMENT STACKS
# ============================================================================
if [ "$CAT_DEV" = true ]; then
  section "SDKMAN"
  [ ! -d "${HOME}/.sdkman" ] && curl -fsSL https://get.sdkman.io | bash
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
  
  for JDK_VER in 8 11 17 21 25; do
    TARGET=$(sdk ls java 2>/dev/null | grep " | tem " | grep " | ${JDK_VER}\." | head -1 | awk '{print $NF}' | grep -iv installed || true)
    [ -n "${TARGET}" ] && sdk i java "${TARGET}" < /dev/null || true
  done
  
  for TOOL in gradle gcn maven mcs ant quarkus micronaut springboot helidon scala sbt groovy kotlin jmc jmeter jreleaser visualvm; do
    sdk i "${TOOL}" < /dev/null 2>/dev/null || true
  done

  # Rust, Ruby, Bun, Ansible
  curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
  [ ! -d "${HOME}/.rbenv" ] && git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv"
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - 2>/dev/null)" || true
  [ ! -d "$(rbenv root)/plugins/ruby-build" ] && git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
  
  curl -fsSL https://bun.sh/install | bash
  pipx install --include-deps ansible && pipx ensurepath
  success "Dev stacks installed"
fi

# ============================================================================
#  2 · PRODUCTIVITY
# ============================================================================
if [ "$CAT_PROD" = true ]; then
  section "Productivity (Fonts, Aria2, Joplin)"
  # Fonts
  mkdir -p "${HOME}/.local/share/fonts"
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AnonymousPro.zip -o /tmp/font.zip
  unzip -oqq /tmp/font.zip 'AnonymousProNerdFontMono*.ttf' -d "${HOME}/.local/share/fonts/" && fc-cache -f
  
  # Aria2
  mkdir -p "${HOME}/.aria2" && touch "${HOME}/.aria2/aria2.session"
  cat <<EOF > "${HOME}/.aria2/aria2.conf"
dir=${HOME}/Downloads
continue=true
input-file=${HOME}/.aria2/aria2.session
save-session=${HOME}/.aria2/aria2.session
save-session-interval=60
EOF
  mkdir -p "${HOME}/.config/systemd/user"
  cat <<EOF > "${HOME}/.config/systemd/user/aria2.service"
[Unit]
Description=aria2c
[Service]
ExecStart=/usr/bin/aria2c --conf-path=${HOME}/.aria2/aria2.conf
Restart=on-failure
[Install]
WantedBy=default.target
EOF
  systemctl --user daemon-reload && systemctl --user enable --now aria2 && loginctl enable-linger "${USER}"
  
  wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
  success "Productivity tools installed"
fi

# ============================================================================
#  3 · UTILITIES
# ============================================================================
if [ "$CAT_UTIL" = true ]; then
  section "Utilities"
  # 7-Zip
  LATEST_7Z=$(curl -sSL "https://www.7-zip.org/download.html" | grep linux-x64.tar.xz | head -1 | cut -d'"' -f6)
  curl -fsSL "https://www.7-zip.org/${LATEST_7Z}" -o /tmp/7z.tar.xz
  mkdir -p "${HOME}/.local/share/7zip" && tar -xf /tmp/7z.tar.xz -C "${HOME}/.local/share/7zip"
  ln -sf "${HOME}/.local/share/7zip/7zz" "${HOME}/.local/bin/7zz"
  
  # yq
  curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o "${HOME}/.local/bin/yq" && chmod +x "${HOME}/.local/bin/yq"
  
  # Oracle
  ORACLE_BASE="https://download.oracle.com/otn_software/linux/instantclient"
  mkdir -p "${HOME}/.local/share/instantclient"
  for PKG in basic sqlplus tools sdk; do
    curl -fsSLO "${ORACLE_BASE}/instantclient-${PKG}-linuxx64.zip" && unzip -oqq -d "${HOME}/.local/share/instantclient" "instantclient-${PKG}-linuxx64.zip" && rm -f "instantclient-${PKG}-linuxx64.zip"
  done
  
  # Helper scripts
  cat <<'EOF' > "${HOME}/scripts/javahome-scan.sh"
#!/bin/bash
# Logic to link SDKMAN candidates to ~/.jdk/ for IDEs
SDKMAN_DIR="${HOME}/.sdkman/candidates"
mkdir -p "${HOME}/.jdk"
for VER in 8 11 17 21 25; do
  SRC=$(ls -d "${SDKMAN_DIR}/java"/*${VER}.0.*-tem 2>/dev/null | tail -1)
  [ -d "${SRC}" ] && ln -sf "${SRC}" "${HOME}/.jdk/jdk-${VER}"
done
EOF
  chmod +x "${HOME}/scripts/javahome-scan.sh" && bash "${HOME}/scripts/javahome-scan.sh"
  success "Utilities installed"
fi

# ============================================================================
echo -e "\n\033[1;32m══════════════════════════════════════════════════════════════"
echo "  ✅  User installation complete!"
echo "  Log: ${LOG_FILE}"
echo -e "══════════════════════════════════════════════════════════════\033[0m"
