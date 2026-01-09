# ~/.zshrc - Minimal, fast zsh configuration

# -----------------------
# 1. Path helpers
# -----------------------
path_add() { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }

path_add "$HOME/.local/bin"
path_add "$HOME/.cargo/bin"

# -----------------------
# 2. Zinit plugin manager
# -----------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Essential plugins (lazy-loaded)
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# -----------------------
# 3. Core settings
# -----------------------
export EDITOR="${EDITOR:-nvim}"
export TERM="xterm-256color"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Vi mode
bindkey -v
bindkey 'jk' vi-cmd-mode

# History substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# -----------------------
# 4. FZF configuration
# -----------------------
export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git'"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"

# File finder with preview
ff() { fzf --height 80% --layout=reverse --preview 'bat --color=always {}'; }

# Find in files
fif() {
  [[ $# -eq 0 ]] && { echo "Usage: fif <term>"; return 1; }
  rg --files-with-matches --no-messages "$1" | fzf --preview "rg --pretty --context 5 '$1' {}"
}

# Git branch checkout
gch() {
  if [[ $# -eq 0 ]]; then
    git branch | fzf | xargs -I {} git checkout {}
  else
    git branch | fzf -q "$1" | xargs -I {} git checkout {}
  fi
}

# -----------------------
# 5. Aliases
# -----------------------
alias vim='nvim'
alias tmux='tmux -u'
alias gfu='git fetch upstream'
alias zshconfig="$EDITOR ~/.zshrc"

# Use eza if available
command -v eza &>/dev/null && alias ls='eza'

# macOS-specific
[[ "$(uname)" == "Darwin" ]] && alias chrome='open -a "Google Chrome"'

# -----------------------
# 6. Tool integrations
# -----------------------
# Starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# FZF shell integration
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# fnm (Fast Node Manager)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
