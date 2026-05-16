#!/bin/bash

source colors.sh

# ── Homebrew ─────────────────────────────────────────────────────────────────
msg_install "Setting up Homebrew"
if test ! $(which brew); then
  msg_install "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  msg_ok "Homebrew installed"
else
  msg_alert "Homebrew already installed"
fi

msg_update "Updating Homebrew"
brew update
brew upgrade
brew cleanup
brew tap buo/cask-upgrade

# ── CLI Tools ─────────────────────────────────────────────────────────────────
msg_install "Installing CLI tools"

tools=(
  "azure-cli"
  "bat"
  "curl"
  "eza"
  "ffmpeg"
  "fzf"
  "gh"
  "git"
  "jq"
  "lazygit"
  "mise"
  "neovim"
  "ollama"
  "pnpm"
  "starship"
  "tree"
  "uv"
  "wget"
  "zoxide"
  "zsh"
  "zsh-syntax-highlighting"
  "zsh-autosuggestions"
  "zsh-completions"
  "zsh-history-substring-search"
)

for tool in "${tools[@]}"; do
  if brew list "$tool" &>/dev/null; then
    msg_checking "$tool already installed"
  else
    msg_install "Installing $tool"
    brew install "$tool"
    msg_ok "$tool installed"
  fi
done

msg_ok "CLI tools installed"

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  msg_install "Installing Oh My Zsh"
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  msg_ok "Oh My Zsh installed"
else
  msg_alert "Oh My Zsh already installed"
fi

# ── Zsh plugins ───────────────────────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  msg_install "Installing zsh-syntax-highlighting plugin"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  msg_ok "zsh-syntax-highlighting installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  msg_install "Installing zsh-autosuggestions plugin"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  msg_ok "zsh-autosuggestions installed"
fi

# ── Mise runtimes ─────────────────────────────────────────────────────────────
msg_install "Configuring mise runtimes"

eval "$(~/.local/bin/mise activate bash)" 2>/dev/null || eval "$(mise activate bash)" 2>/dev/null

# Write global mise config
mkdir -p "$HOME/.config/mise"
cat > "$HOME/.config/mise/config.toml" << 'EOF'
[tools]
node    = "latest"
elixir  = "latest"
erlang  = "latest"
ruby    = "latest"
python  = "3.10"
EOF

msg_install "Installing mise runtimes (this may take a while)"
mise install
msg_ok "Mise runtimes installed"
