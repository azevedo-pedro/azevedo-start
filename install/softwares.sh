#!/bin/bash

source colors.sh

msg_install "Installing apps with Homebrew Cask"

cask=(
  "arc"
  "bitwarden"
  "claude"
  "figma"
  "font-fira-code-nerd-font"
  "ghostty"
  "google-chrome"
  "microsoft-teams"
  "obsidian"
  "orbstack"
  "raycast"
  "telegram"
  "visual-studio-code"
  "vlc"
  "whatsapp"
  "yaak"
)

for app in "${cask[@]}"; do
  if brew list --cask "$app" &>/dev/null; then
    msg_checking "$app already installed"
  else
    msg_install "Installing $app"
    brew install --cask "$app"
    msg_ok "$app installed"
  fi
done

msg_ok "All apps installed"
