# azevedo-start

Setup script to restore a fresh macOS machine to my full dev environment.

## Install

```bash
curl -L https://raw.github.com/azevedo-pedro/azevedo-start/main/install.sh | bash
```

The script clones the repo to `~/.azevedo-start` — a hidden folder directly in `~`, isolated from
any dev projects inside `~/Developer/`. All config symlinks point there, so nothing breaks if you
reorganize your project folders later.

### Manual clone

If you prefer to set it up yourself:

```bash
git clone https://github.com/azevedo-pedro/azevedo-start.git ~/.azevedo-start
cd ~/.azevedo-start
bash install.sh
```

### Copying from an existing machine

If you already have the repo somewhere (e.g. `~/Developer/azevedo-start`) and just want to move it
to the canonical location before formatting:

```bash
cp -r ~/Developer/azevedo-start ~/.azevedo-start
```

Then push any local changes before formatting:

```bash
cd ~/.azevedo-start
git push
```

## What gets installed

### CLI Tools (Homebrew)
`azure-cli` `bat` `curl` `eza` `ffmpeg` `fzf` `gh` `git` `jq` `lazygit` `mise` `neovim` `ollama` `pnpm` `starship` `tree` `uv` `wget` `zoxide` `zsh` + zsh plugins

### Apps (Homebrew Cask)
`arc` `bitwarden` `claude` `figma` `font-fira-code-nerd-font` `ghostty` `google-chrome` `microsoft-teams` `obsidian` `orbstack` `raycast` `telegram` `visual-studio-code` `vlc` `whatsapp` `yaak`

### Runtimes (mise)
| Runtime | Version |
|---------|---------|
| Node.js | latest  |
| Elixir  | latest  |
| Erlang  | latest  |
| Ruby    | latest  |
| Python  | 3.10    |

### Shell
- Oh My Zsh with `af-magic` theme and custom git prompt
- Plugins: `zsh-syntax-highlighting`, `zsh-autosuggestions`
- Aliases and history settings

### Configs (symlinked)
| File | Target |
|------|--------|
| `settings/.zshrc` | `~/.zshrc` |
| `settings/.aliases` | `~/.aliases` |
| `settings/.npmrc` | `~/.npmrc` |
| `settings/.editorconfig` | `~/.editorconfig` |
| `settings/git/.gitconfig` | `~/.gitconfig` |
| `settings/git/.gitignore` | `~/.gitignore` |
| `settings/ghostty/` | `~/.config/ghostty/` |
| `settings/nvim/` | `~/.config/nvim/` |
| `settings/claude/settings.json` | `~/.claude/settings.json` |

## Manual steps after install

1. **Azure DevOps PAT** — open `~/.zshrc` and set your token:
   ```bash
   export AZURE_DEVOPS_EXT_PAT=<your-token-here>
   export AZURE_DEVOPS_PAT=$AZURE_DEVOPS_EXT_PAT
   ```

2. **Git SSH keys** — run the interactive script:
   ```bash
   bash ~/.azevedo-start/settings/git/git-script.sh
   ```

3. **Claude login**:
   ```bash
   claude login
   ```

4. **OrbStack** — open the app and complete setup (Docker/VM integration)

5. **Raycast** — open and configure extensions/hotkeys

## Structure

```
azevedo-start/
├── install.sh              # entry point
├── colors.sh               # colored output helpers
├── install/
│   ├── environment.sh      # homebrew + CLI tools + mise runtimes
│   ├── softwares.sh        # cask apps
│   ├── settings.sh         # symlinks
│   └── claude.sh           # Claude Code CLI
└── settings/
    ├── .zshrc
    ├── .aliases
    ├── .npmrc
    ├── .editorconfig
    ├── git/
    │   ├── .gitconfig
    │   ├── .gitignore
    │   └── git-script.sh
    ├── ghostty/
    │   ├── config
    │   └── catppuccin-mocha
    ├── nvim/               # LazyVim config
    └── claude/
        └── settings.json
```
