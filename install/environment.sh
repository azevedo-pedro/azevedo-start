#!/bin/bash

# ── Homebrew ─────────────────────────────────────────────────────────────────
msg_install "Setting up Homebrew"

if ! command -v brew &>/dev/null; then
  msg_install "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Detecta o prefixo correto (Apple Silicon vs Intel)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    msg_alert "Homebrew binary not found after install — aborting"
    exit 1
  fi

  msg_ok "Homebrew installed"
else
  msg_checking "Homebrew already installed"
  # Garante que o PATH está correto mesmo se já estava instalado
  eval "$(brew shellenv)"
fi

msg_update "Updating Homebrew"
brew update
# upgrade: falha não é crítica (nada pra atualizar retorna non-zero às vezes)
brew upgrade || true
brew cleanup

# ── CLI Tools ─────────────────────────────────────────────────────────────────
msg_install "Installing CLI tools"

brew_install() {
  local pkg="$1"
  if brew list "$pkg" &>/dev/null; then
    msg_checking "$pkg already installed"
  else
    msg_install "Installing $pkg"
    if brew install "$pkg"; then
      msg_ok "$pkg installed"
    else
      msg_alert "Failed to install $pkg"
      FAILED+=("brew: $pkg")
    fi
  fi
}

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
  brew_install "$tool"
done

msg_ok "CLI tools done"

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  msg_install "Installing Oh My Zsh"
  # RUNZSH=no  → não inicia um novo shell ao terminar (crítico: sem isso o script para aqui)
  # CHSH=no    → não tenta mudar o shell padrão (requer senha e pode travar)
  # KEEP_ZSHRC=yes → não sobrescreve o .zshrc existente (o symlink será criado depois)
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  msg_ok "Oh My Zsh installed"
else
  msg_checking "Oh My Zsh already installed"
fi

# ── Zsh plugins ───────────────────────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  msg_install "Installing zsh-syntax-highlighting plugin"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  msg_ok "zsh-syntax-highlighting installed"
else
  msg_checking "zsh-syntax-highlighting already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  msg_install "Installing zsh-autosuggestions plugin"
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  msg_ok "zsh-autosuggestions installed"
else
  msg_checking "zsh-autosuggestions already installed"
fi

# ── Mise runtimes ─────────────────────────────────────────────────────────────
msg_install "Configuring mise runtimes"

# Resolve o caminho do mise via brew (não depende do shim ainda)
MISE_BIN="$(brew --prefix)/bin/mise"

if [[ ! -x "$MISE_BIN" ]]; then
  msg_alert "mise binary not found at $MISE_BIN — skipping runtime install"
  FAILED+=("mise runtimes (mise not found)")
else
  # Escreve o config global ANTES de instalar
  mkdir -p "$HOME/.config/mise"
  cat > "$HOME/.config/mise/config.toml" << 'EOF'
[tools]
node   = "latest"
elixir = "latest"
erlang = "latest"
ruby   = "latest"
python = "3.10"
EOF

  msg_install "Installing mise runtimes — this may take several minutes"
  if "$MISE_BIN" install; then
    msg_ok "Mise runtimes installed"
  else
    msg_alert "One or more mise runtimes failed to install"
    FAILED+=("mise runtimes")
  fi

  # Adiciona os shims ao PATH desta sessão para que npm fique disponível no claude.sh
  export PATH="$HOME/.local/share/mise/shims:$PATH"
fi
