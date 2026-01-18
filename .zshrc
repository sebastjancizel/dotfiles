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

# Load completions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Essential plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

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
mkcd() { mkdir -p "$1" && cd "$1"; }

alias vim='nvim'
alias tmux='tmux -u'
alias zshconfig="$EDITOR ~/.zshrc"

# Git aliases (from oh-my-zsh git plugin)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gss='git status --short'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcmsg='git commit --message'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune'
alias gfu='git fetch upstream'
alias gm='git merge'
alias grb='git rebase'
alias grbi='git rebase --interactive'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbm='git rebase $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grh='git reset'
alias grhh='git reset --hard'
alias grs='git restore'
alias grst='git restore --staged'

# Use eza if available
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias l='eza -al'
else
  alias l='ls -al'
fi

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

# Zoxide (fast cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
