#!/usr/bin/env bash
# ============================================================================
#  Ubuntu Software Installation Script — User
#  Run as: bash install-user.sh       (do NOT use sudo)
#  Tested on: Ubuntu 24.04+ (Noble)
# ============================================================================
set -euo pipefail

echo "══════════════════════════════════════════════════════════════"
echo "  Ubuntu User Installer"
echo "  User : ${USER}"
echo "  Home : ${HOME}"
echo "══════════════════════════════════════════════════════════════"

# ── Helpers ────────────────────────────────────────────────────────────────
section()  { echo -e "\n\033[1;36m▸ $1\033[0m"; }
success()  { echo -e "\033[1;32m  ✔ $1\033[0m"; }

# ── Umask & directories ───────────────────────────────────────────────────
umask 0027
grep -qxF "umask 0027" "${HOME}/.bashrc" 2>/dev/null || \
  echo "umask 0027" >> "${HOME}/.bashrc"

mkdir -p "${HOME}/scripts" "${HOME}/.local/bin"
source "${HOME}/.profile" 2>/dev/null || true

# ============================================================================
#  1 · GIT CONFIGURATION
# ============================================================================
section "Git Configuration"
ssh-keygen -t ed25519 -C "github@${USER}@${HOSTNAME}" \
  -f "${HOME}/.ssh/id_ed25519_github" -N "" 2>/dev/null || true
git config --global user.name  'Azman Kudus'
git config --global user.email 'aa.azmankudus@outlook.my'
git config --global core.sshCommand "ssh -i ${HOME}/.ssh/id_ed25519_github"
success "Git configured"

# ============================================================================
#  2 · VIM CONFIGURATION
# ============================================================================
section "Vim Config"
echo 'set mouse-=a' > "${HOME}/.vimrc"
success "Vim configured"

# ============================================================================
#  3 · SDKMAN + JDK/TOOLS
# ============================================================================
section "SDKMAN"
if [ ! -d "${HOME}/.sdkman" ]; then
  curl -fsSL https://get.sdkman.io | bash
fi
source "${HOME}/.sdkman/bin/sdkman-init.sh"

section "Java (Temurin JDKs: 8, 11, 17, 21, 25)"
for JDK_VER in 8 11 17 21 25; do
  TARGET=$(sdk ls java 2>/dev/null \
    | grep " | tem " | grep " | ${JDK_VER}\\." \
    | head -1 | awk '{print $NF}' | grep -iv installed || true)
  if [ -n "${TARGET}" ]; then
    echo "  Installing Java ${TARGET} ..."
    sdk i java "${TARGET}" < /dev/null || true
  fi
done
success "Java JDKs installed"

section "SDKMAN Tools"
for TOOL in gradle gcn maven mcs ant quarkus micronaut springboot \
            helidon scala sbt groovy kotlin jmc jmeter jreleaser visualvm; do
  sdk i "${TOOL}" < /dev/null 2>/dev/null || true
done
success "SDKMAN tools installed"

# ── JAVA_HOME helper script ────────────────────────────────────────────────
section "JAVA_HOME Helper Script"
cat <<'SCRIPT' > "${HOME}/scripts/javahome-scan.sh"
#!/bin/bash
SDKMAN_JDK_PATH=${HOME}/.sdkman/candidates/java
declare -a VERSIONS=(8 11 17 21 25)
mkdir -p ${HOME}/.jdk

for VER in "${VERSIONS[@]}"; do
  JDK_DIR=${HOME}/.jdk/jdk-${VER}
  declare -x "JAVA_HOME_${VER}=${HOME}/.jdk/jdk-${VER}"
  SDKMAN_JDK=$(ls -d ${SDKMAN_JDK_PATH}/*${VER}.0.*-tem 2>/dev/null | tail -1)
  if [ -d "${SDKMAN_JDK}" ]; then
    rm -f ${JDK_DIR}
    ln -s ${SDKMAN_JDK} ${JDK_DIR}
    declare -x "JAVA_HOME=${JDK_DIR}"
    declare -x "PATH=${JDK_DIR}/bin:${PATH}"
  fi
done

SDKMAN_GRADLE_PATH=${HOME}/.sdkman/candidates/gradle
GRADLE_DIR=${HOME}/.jdk/gradle
declare -x "GRADLE_HOME=${GRADLE_DIR}"
SDKMAN_GRADLE=$(ls -d ${SDKMAN_GRADLE_PATH}/* 2>/dev/null | grep -v current | tail -1)
if [ -d "${SDKMAN_GRADLE}" ]; then
  rm -f ${GRADLE_DIR}
  ln -s ${SDKMAN_GRADLE} ${GRADLE_DIR}
  declare -x "PATH=${GRADLE_DIR}/bin:${PATH}"
fi

SDKMAN_MAVEN_PATH=${HOME}/.sdkman/candidates/maven
MAVEN_DIR=${HOME}/.jdk/maven
declare -x "M2_HOME=${MAVEN_DIR}"
SDKMAN_MAVEN=$(ls -d ${SDKMAN_MAVEN_PATH}/* 2>/dev/null | grep -v current | tail -1)
if [ -d "${SDKMAN_MAVEN}" ]; then
  rm -f ${MAVEN_DIR}
  ln -s ${SDKMAN_MAVEN} ${MAVEN_DIR}
  declare -x "PATH=${MAVEN_DIR}/bin:${PATH}"
fi
SCRIPT
chmod +x "${HOME}/scripts/javahome-scan.sh"
bash "${HOME}/scripts/javahome-scan.sh"
success "JAVA_HOME helper created"

# ============================================================================
#  4 · FONTS
# ============================================================================
section "AnonymousPro Nerd Font"
mkdir -p "${HOME}/.local/share/fonts"
curl -fsSL -o /tmp/AnonymousPro.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AnonymousPro.zip
unzip -oqq /tmp/AnonymousPro.zip 'AnonymousProNerdFontMono*.ttf' -d "${HOME}/.local/share/fonts/"
rm -f /tmp/AnonymousPro.zip
fc-cache -f 2>/dev/null || true
success "AnonymousPro Nerd Font installed"

# ============================================================================
#  5 · ARIA2 (as user service)
# ============================================================================
section "Aria2 Configuration"
mkdir -p "${HOME}/.aria2"
touch "${HOME}/.aria2/aria2.session"
cat <<EOF > "${HOME}/.aria2/aria2.conf"
dir=${HOME}/Downloads
continue=true
input-file=${HOME}/.aria2/aria2.session
save-session=${HOME}/.aria2/aria2.session
save-session-interval=60
file-allocation=prealloc

enable-rpc=true
rpc-listen-all=false
rpc-listen-port=6800
rpc-secret=abcdef123456

max-concurrent-downloads=5
split=16
min-split-size=1M
EOF

mkdir -p "${HOME}/.config/systemd/user"
cat <<EOF > "${HOME}/.config/systemd/user/aria2.service"
[Unit]
Description=aria2c Download Manager with RPC
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/aria2c --conf-path=${HOME}/.aria2/aria2.conf
Restart=on-failure

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now aria2
loginctl enable-linger "${USER}"
success "Aria2 configured as user service"

# ============================================================================
#  6 · RUST
# ============================================================================
section "Rust"
curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
success "Rust installed"

# ============================================================================
#  7 · RUBY (rbenv)
# ============================================================================
section "Ruby (rbenv)"
if [ ! -d "${HOME}/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv"
fi
export PATH="${HOME}/.rbenv/bin:${PATH}"
eval "$(rbenv init - 2>/dev/null)" || true
if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
fi
rbenv install -l 2>/dev/null | grep -P '^(3\.3|3\.4|4\.0)' \
  | xargs -I {} rbenv install {} 2>/dev/null || true
success "Ruby installed via rbenv"

# ============================================================================
#  8 · BUN
# ============================================================================
section "Bun"
curl -fsSL https://bun.sh/install | bash
success "Bun installed"

# ============================================================================
#  9 · 7-ZIP
# ============================================================================
section "7-Zip"
LATEST_7Z=$(curl -sSL "https://www.7-zip.org/download.html" 2>/dev/null \
  | grep linux-x64.tar.xz | head -1 | cut -d'"' -f6)
curl -fsSL -o /tmp/7zip.tar.xz "https://www.7-zip.org/${LATEST_7Z}"
rm -rf "${HOME}/.local/share/7zip"
mkdir -p "${HOME}/.local/share/7zip"
tar -x -C "${HOME}/.local/share/7zip" -f /tmp/7zip.tar.xz
ln -sf "${HOME}/.local/share/7zip/7zz"  "${HOME}/.local/bin/7zz"
ln -sf "${HOME}/.local/share/7zip/7zzs" "${HOME}/.local/bin/7zzs"
rm -f /tmp/7zip.tar.xz
success "7-Zip installed"

# ============================================================================
# 10 · YQ
# ============================================================================
section "yq"
curl -fsSL -o "${HOME}/.local/bin/yq" \
  https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod 755 "${HOME}/.local/bin/yq"
success "yq installed"

# ============================================================================
# 11 · ANSIBLE
# ============================================================================
section "Ansible (pipx)"
pipx install --include-deps ansible
pipx ensurepath
pipx completions
success "Ansible installed"

# ============================================================================
# 12 · ORACLE INSTANT CLIENT
# ============================================================================
section "Oracle Instant Client"
ORACLE_BASE="https://download.oracle.com/otn_software/linux/instantclient"
for PKG in basic sqlplus tools sdk jdbc odbc; do
  curl -fsSLO "${ORACLE_BASE}/instantclient-${PKG}-linuxx64.zip"
done
mkdir -p "${HOME}/.local/share/instantclient"
ls instantclient-*-linuxx64.zip 2>/dev/null \
  | xargs -I {} unzip -oqq -d "${HOME}/.local/share/instantclient" {} 'instantclient*'
rm -f instantclient-*-linuxx64.zip

grep -q 'ORACLE_HOME' "${HOME}/.bashrc" 2>/dev/null || \
cat <<'EOF' >> "${HOME}/.bashrc"

# Oracle Database InstantClient
export ORACLE_HOME=${HOME}/.local/share/instantclient
export TNS_ADMIN=${ORACLE_HOME}/network/admin
export PATH=${ORACLE_HOME}/bin:${PATH}
EOF
success "Oracle Instant Client installed"

# ============================================================================
# 13 · JOPLIN
# ============================================================================
section "Joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
success "Joplin installed"

# ============================================================================
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  ✅  User installation complete!"
echo "  ➡  Restart your shell or log out / log in to apply changes"
echo "══════════════════════════════════════════════════════════════"
