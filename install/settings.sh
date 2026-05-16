#!/bin/bash

START="$HOME/.azevedo-start"

symlink() {
  local src="$1"
  local dest="$2"
  local label="$3"

  # Segurança: não executa rm se algum dos paths estiver vazio
  if [[ -z "$src" || -z "$dest" ]]; then
    msg_alert "symlink: src ou dest vazio para '$label' — pulando"
    return 1
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    msg_update "$label"
    rm -rf "$dest"
  else
    msg_install "$label"
  fi

  ln -sf "$src" "$dest"
  msg_checking "$label"
}

# ── Dotfiles ──────────────────────────────────────────────────────────────────
symlink "$START/settings/.editorconfig"   "$HOME/.editorconfig"     ".editorconfig"
symlink "$START/settings/.aliases"        "$HOME/.aliases"          ".aliases"
symlink "$START/settings/.npmrc"          "$HOME/.npmrc"            ".npmrc"
symlink "$START/settings/.zshrc"          "$HOME/.zshrc"            ".zshrc"
symlink "$START/settings/git/.gitconfig"  "$HOME/.gitconfig"        ".gitconfig"
symlink "$START/settings/git/.gitignore"  "$HOME/.gitignore"        ".gitignore"

# ── Ghostty ───────────────────────────────────────────────────────────────────
mkdir -p "$HOME/.config/ghostty"
symlink "$START/settings/ghostty/config"           "$HOME/.config/ghostty/config"           "ghostty config"
symlink "$START/settings/ghostty/catppuccin-mocha" "$HOME/.config/ghostty/catppuccin-mocha" "ghostty theme"

# ── Neovim ────────────────────────────────────────────────────────────────────
mkdir -p "$HOME/.config"
symlink "$START/settings/nvim" "$HOME/.config/nvim" "neovim config"

# ── Claude Code ───────────────────────────────────────────────────────────────
mkdir -p "$HOME/.claude"
symlink "$START/settings/claude/settings.json" "$HOME/.claude/settings.json" "claude settings"

msg_ok "All settings applied"
