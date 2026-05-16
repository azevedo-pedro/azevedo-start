#!/bin/bash

msg_install "Installing apps with Homebrew Cask"

brew_cask_install() {
  local app="$1"
  if brew list --cask "$app" &>/dev/null; then
    msg_checking "$app already installed"
  else
    msg_install "Installing $app"
    if brew install --cask "$app"; then
      msg_ok "$app installed"
    else
      msg_alert "Failed to install $app"
      FAILED+=("cask: $app")
    fi
  fi
}

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
  brew_cask_install "$app"
done

msg_ok "Cask apps done"
