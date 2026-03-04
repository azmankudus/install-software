umask 0027
cat <<EOF >> ${HOME}/.bashrc

umask 0027
EOF

mkdir -p ${HOME}/scripts
mkdir -p ${HOME}/.local/bin
source ${HOME}/.profile

ssh-keygen -t ed25519 -C "github@${USER}@${HOSTNAME}" -f ${HOME}/.ssh/id_ed25519_github
git config --global user.name 'Azman Kudus'
git config --global user.name 'aa.azmankudus@outlook.my'
git config --global core.sshCommand "ssh -i ${HOME}/.ssh/id_ed25519_github"

echo 'set mouse-=a' > ${HOME}/.vimrc

# SDKman (user)
curl -fsSL https://get.sdkman.io | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh"
printf '8\n11\n17\n21\n25' | xargs -n 1 bash -c 'source "${HOME}/.sdkman/bin/sdkman-init.sh"; TARGET_VERSION=$(sdk ls java | grep " | tem " | grep " | $1." | head -1 | awk "{print \$NF}" | grep -iv installed); echo "Installing ${TARGET_VERSION}"; sdk i java ${TARGET_VERSION}' {}
sdk i gradle
sdk i gcn
sdk i maven
sdk i mcs
sdk i ant
sdk i quarkus
sdk i micronaut
sdk i springboot
sdk i helidon
sdk i scala
sdk i sbt
sdk i groovy
sdk i kotlin
sdk i jmc
sdk i jmeter
sdk i jreleaser
sdk i visualvm

cat <<EOF > ${HOME}/scripts/javahome-scan.sh
#!/bin/bash

SDKMAN_JDK_PATH=\${HOME}/.sdkman/candidates/java
declare -a VERSIONS=(8 11 17 21 25)
mkdir -p \${HOME}/.jdk

for VER in "\${VERSIONS[@]}"; do
  JDK_DIR=\${HOME}/.jdk/jdk-\${VER}
  declare -x "JAVA_HOME_\${VER}=\${HOME}/.jdk/jdk-\${VER}"
  SDKMAN_JDK=\$(ls -d \${SDKMAN_JDK_PATH}/*\${VER}.0.*-tem | tail -1)
  if [ -d "\${SDKMAN_JDK}" ]; then
    rm -f \${JDK_DIR}
    ln -s \${SDKMAN_JDK} \${JDK_DIR}
    declare -x "JAVA_HOME=\${JDK_DIR}"
    declare -x "PATH=\${JDK_DIR}/bin:\${PATH}"
  fi
done

SDKMAN_GRADLE_PATH=\${HOME}/.sdkman/candidates/gradle
GRADLE_DIR=\${HOME}/.jdk/gradle
declare -x "GRADLE_HOME=\${GRADLE_DIR}"
SDKMAN_GRADLE=\$(ls -d \${SDKMAN_GRADLE_PATH}/* | grep -v current | tail -1)
if [ -d "\${SDKMAN_GRADLE}" ]; then
  rm -f \${GRADLE_DIR}
  ln -s \${SDKMAN_GRADLE} \${GRADLE_DIR}
  declare -x "PATH=\${GRADLE_DIR}/bin:\${PATH}"
fi

SDKMAN_MAVEN_PATH=\${HOME}/.sdkman/candidates/maven
MAVEN_DIR=\${HOME}/.jdk/maven
declare -x "M2_HOME=\${MAVEN_DIR}"
SDKMAN_MAVEN=\$(ls -d \${SDKMAN_MAVEN_PATH}/* | grep -v current | tail -1)
if [ -d "\${SDKMAN_MAVEN}" ]; then
  rm -f \${MAVEN_DIR}
  ln -s \${SDKMAN_MAVEN} \${MAVEN_DIR}
  declare -x "PATH=\${MAVEN_DIR}/bin:\${PATH}"
fi
EOF

bash ${HOME}/scripts/javahome-scan.sh

# AnonymousPro Nerd Font
curl -fsSL -o AnonymousPro.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AnonymousPro.zip
unzip -oqq AnonymousPro.zip 'AnonymousProNerdFontMono*.ttf'
rm -f AnonymousPro.zip

# Aria2
mkdir -p ~/.aria2
touch ~/.aria2/aria2.session
cat <<EOF > ~/.aria2/aria2.conf
dir=$HOME/Downloads
continue=true
input-file=$HOME/.aria2/aria2.session
save-session=$HOME/.aria2/aria2.session
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
mkdir -p $HOME/.config/systemd/user
cat <<EOF > $HOME/.config/systemd/user/aria2.service
[Unit]
Description=aria2c Download Manager with RPC
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/aria2c --conf-path=$HOME/.aria2/aria2.conf
Restart=on-failure

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now aria2
loginctl enable-linger $USER

# Rust
curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path

# Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
${HOME}/.rbenv/bin/rbenv init
source ${HOME}/.bashrc
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install -l | grep -P '^(3.3|3.4|4.0)' | xargs -I {} rbenv install {}

# Bun
curl -fsSL https://bun.sh/install | bash

# 7zip
LATEST_PACKAGE=$(curl -sSL "https://www.7-zip.org/download.html" 2> /dev/null | grep linux-x64.tar.xz | head -1 | cut -d'"' -f6)
curl -fsSL -o 7zip.tar.xz "https://www.7-zip.org/${LATEST_PACKAGE}"
rm -rf ${HOME}/.local/share/7zip
mkdir -p ${HOME}/.local/share/7zip
tar -x -C ${HOME}/.local/share/7zip -f 7zip.tar.xz
ln -s ${HOME}/.local/share/7zip/7zz ${HOME}/.local/bin/7zz
ln -s ${HOME}/.local/share/7zip/7zzs ${HOME}/.local/bin/7zzs

# yq
curl -fsSL -o ${HOME}/.local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod 755 ${HOME}/.local/bin/yq

# Ansible
pipx install --include-deps ansible
pipx ensurepath
pipx completions

# Oracle Client
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip'
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip'
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-tools-linuxx64.zip'
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-linuxx64.zip'
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-jdbc-linuxx64.zip'
curl -fsSLO 'https://download.oracle.com/otn_software/linux/instantclient/instantclient-odbc-linuxx64.zip'
mkdir -p ${HOME}/.local/share/instantclient
ls instantclient-*-linuxx64.zip | xargs -I {} unzip -oqq -d ${HOME}/.local/share/instantclient {} 'instantclient*'
rm -f instantclient-*-linuxx64.zip
cat <<EOF >> ${HOME}/.bashrc

# Oracle Database InstantClient
export ORACLE_HOME=\${HOME}/.local/share/instantclient
export TNS_ADMIN=\${ORACLE_HOME}/network/admin
export PATH=\${ORACLE_HOME}/bin:\${PATH}
EOF

# SQL Developer
https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-24.3.1.347.1826-no-jre.zip

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

