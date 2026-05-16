# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="af-magic"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Sources
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# History settings
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000

setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# ASDF shims (legacy, kept for compatibility)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# Mise version manager
eval "$(~/.local/bin/mise activate zsh)"

# Azure DevOps — set your PAT here (do NOT commit the actual token)
# export AZURE_DEVOPS_EXT_PAT=<your-token-here>
# export AZURE_DEVOPS_PAT=$AZURE_DEVOPS_EXT_PAT

# Custom prompt (override af-magic: input on new line)
PROMPT='%F{cyan}%~%f $(git_prompt_info)%{$reset_color%}
➜ '

ZSH_THEME_GIT_PROMPT_PREFIX="%F{green}(%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{green})%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""
