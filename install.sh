#!/bin/bash
set -euo pipefail

START="$HOME/.azevedo-start"

if [[ -d $START ]]; then
  echo 'Checking azevedo-start directory'
else
  echo 'Cloning azevedo-start'
  git clone https://github.com/azevedo-pedro/azevedo-start.git "$START"
fi

cd "$START"

source colors.sh

# Falhas não-críticas são coletadas aqui e reportadas no final
FAILED=()

trap 'msg_alert "Setup interrupted at line $LINENO. Re-run the script to continue — it is safe to rerun."' ERR

msg "Starting azevedo-start setup..."

source install/environment.sh
source install/softwares.sh
source install/settings.sh
source install/claude.sh

# ── Relatório final ───────────────────────────────────────────────────────────
echo ""
if [[ ${#FAILED[@]} -gt 0 ]]; then
  msg_alert "Setup completed with ${#FAILED[@]} failure(s):"
  for item in "${FAILED[@]}"; do
    msg_alert "  ✖ $item"
  done
  msg "Re-run the script to retry failed items — already installed items will be skipped."
else
  msg_ok "Setup complete! All items installed successfully."
fi

echo ""
msg "Restart your terminal (or run: source ~/.zshrc)"
