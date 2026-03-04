#!/usr/bin/env bash
# ============================================================================
#  Config Sync Script — Ubuntu
#  Automatically links files from config/ to their system locations.
#  Run as: bash sync-configs.sh
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/../config"

section()  { echo -e "\n\033[1;36m▸ $1\033[0m"; }
success()  { echo -e "\033[1;32m  ✔ $1\033[0m"; }

section "Syncing Configurations"

# Oh My Posh
if [ -f "${CONFIG_DIR}/oh-my-posh.json" ]; then
  mkdir -p "${HOME}/.config/oh-my-posh"
  ln -sf "${CONFIG_DIR}/oh-my-posh.json" "${HOME}/.config/oh-my-posh/default.json"
  success "Oh My Posh config linked"
fi

# Easy Effects
if [ -d "${CONFIG_DIR}/easyeffects" ]; then
  mkdir -p "${HOME}/.config/easyeffects/output"
  ln -sf "${CONFIG_DIR}/easyeffects/hp.json" "${HOME}/.config/easyeffects/output/hp.json"
  ln -sf "${CONFIG_DIR}/easyeffects/spk.json" "${HOME}/.config/easyeffects/output/spk.json"
  success "Easy Effects presets linked"
fi

success "Sync complete!"
