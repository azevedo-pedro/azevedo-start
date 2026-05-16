#!/bin/bash

source colors.sh

msg_install "Installing Claude Code CLI"

if command -v claude &>/dev/null; then
  msg_checking "Claude Code already installed ($(claude --version))"
else
  npm install -g @anthropic-ai/claude-code
  msg_ok "Claude Code installed"
fi

# ── Post-install reminders ────────────────────────────────────────────────────
msg ""
msg "┌─────────────────────────────────────────────────────────┐"
msg "│  Manual steps required after setup:                    │"
msg "│                                                         │"
msg "│  1. Set your Azure DevOps PAT in ~/.zshrc:             │"
msg "│     export AZURE_DEVOPS_EXT_PAT=<your-token>           │"
msg "│                                                         │"
msg "│  2. Update Azure DevOps org URL in:                    │"
msg "│     ~/.claude/settings.json (mcpServers section)       │"
msg "│                                                         │"
msg "│  3. Run git-script.sh to set up SSH keys:              │"
msg "│     bash ~/Developer/azevedo-start/settings/git/git-script.sh │"
msg "│                                                         │"
msg "│  4. Sign in to Claude:  claude login                   │"
msg "└─────────────────────────────────────────────────────────┘"
