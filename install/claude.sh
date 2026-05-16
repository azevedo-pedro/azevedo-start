#!/bin/bash

msg_install "Installing Claude Code CLI"

if command -v claude &>/dev/null; then
  msg_checking "Claude Code already installed ($(claude --version 2>/dev/null || echo 'version unknown'))"
else
  # npm vem do Node instalado via mise — os shims foram adicionados ao PATH no environment.sh
  if command -v npm &>/dev/null; then
    if npm install -g @anthropic-ai/claude-code; then
      msg_ok "Claude Code installed"
    else
      msg_alert "Claude Code install failed"
      FAILED+=("claude-code (npm)")
    fi
  else
    msg_alert "npm not found in PATH — Claude Code not installed"
    FAILED+=("claude-code (npm not available)")
  fi
fi

# ── Post-install reminders ────────────────────────────────────────────────────
echo ""
msg "┌─────────────────────────────────────────────────────────────┐"
msg "│  Passos manuais após o setup:                               │"
msg "│                                                             │"
msg "│  1. Defina seu Azure DevOps PAT no ~/.zshrc:               │"
msg "│     export AZURE_DEVOPS_EXT_PAT=<seu-token>                │"
msg "│                                                             │"
msg "│  2. Configure SSH keys para git:                           │"
msg "│     bash ~/.azevedo-start/settings/git/git-script.sh       │"
msg "│                                                             │"
msg "│  3. Faça login no Claude:                                  │"
msg "│     claude login                                            │"
msg "│                                                             │"
msg "│  4. Abra OrbStack e Raycast para finalizar a configuração  │"
msg "└─────────────────────────────────────────────────────────────┘"
