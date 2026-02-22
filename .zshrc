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

# Open file explorer in current directory (cross-platform)
ofd() {
  case "$(uname -s)" in
    Darwin) open "${1:-.}" ;;
    Linux)  xdg-open "${1:-.}" &>/dev/null & disown ;;
    *)      echo "Unsupported OS" && return 1 ;;
  esac
}

# Copy current directory path to clipboard
cpwd() {
  case "$(uname -s)" in
    Darwin) pwd | tr -d '\n' | pbcopy ;;
    Linux)  pwd | tr -d '\n' | xclip -selection clipboard ;;
  esac
  echo "Copied: $(pwd)"
}

# Universal archive extraction
extract() {
  [[ ! -f "$1" ]] && { echo "Error: '$1' not found"; return 1; }
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.zip)     unzip "$1" ;;
    *.7z)      7z x "$1" ;;
    *.rar)     unrar x "$1" ;;
    *)         echo "Unknown format: '$1'" && return 1 ;;
  esac
}

# Go up N directories
up() {
  local count="${1:-1}"
  local dir=""
  for ((i = 0; i < count; i++)); do dir+="../"; done
  cd "$dir" || return
}

# Quick local HTTP server
serve() {
  local port="${1:-8000}"
  echo "Serving on http://localhost:$port"
  python3 -m http.server "$port"
}

# Show processes listening on ports
ports() {
  case "$(uname -s)" in
    Darwin) lsof -iTCP -sTCP:LISTEN -n -P ;;
    Linux)  ss -tulnp ;;
  esac
}

# Kill process on a specific port
killport() {
  [[ -z "$1" ]] && { echo "Usage: killport <port>"; return 1; }
  local pid
  case "$(uname -s)" in
    Darwin) pid=$(lsof -ti ":$1") ;;
    Linux)  pid=$(fuser "$1/tcp" 2>/dev/null) ;;
  esac
  [[ -z "$pid" ]] && { echo "No process on port $1"; return 1; }
  kill -9 $pid && echo "Killed process $pid on port $1"
}

# Show public IP address
myip() { curl -s https://ipinfo.io/ip && echo; }

# Move to trash instead of rm (safer)
trash() {
  [[ $# -eq 0 ]] && { echo "Usage: trash <file>..."; return 1; }
  case "$(uname -s)" in
    Darwin)
      for f in "$@"; do mv "$f" ~/.Trash/; done ;;
    Linux)
      local trash_dir="${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files"
      mkdir -p "$trash_dir"
      for f in "$@"; do mv "$f" "$trash_dir/"; done ;;
  esac
}

# Tree with sensible ignores
tre() {
  tree -a -I '.git|node_modules|.venv|__pycache__|.DS_Store' --dirsfirst "${@:-.}"
}

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

# -----------------------
# 7. Shell help & welcome
# -----------------------
shelp() {
  cat << 'EOF'
  Shortcuts:
    mkcd <dir>      Create directory and cd into it
    ofd [dir]       Open file explorer (default: current dir)
    cpwd            Copy current path to clipboard
    extract <file>  Extract any archive (tar, zip, 7z, rar, etc.)
    up [N]          Go up N directories (default: 1)
    serve [port]    Start HTTP server (default: 8000)
    ports           Show processes listening on ports
    killport <port> Kill process on port
    myip            Show public IP address
    trash <file>    Move to trash instead of rm
    tre [dir]       Tree with sensible ignores

  FZF:
    ff              Find file with preview
    fif <term>      Find in files
    gch [query]     Git checkout branch with fzf

  Type 'shelp' anytime to see this again.
  Disable welcome: touch ~/.hushlogin or export QUIET_SHELL=1
EOF
}

# Show welcome message (disable with ~/.hushlogin or QUIET_SHELL=1)
if [[ ! -f ~/.hushlogin && -z "$QUIET_SHELL" && $- == *i* ]]; then
  echo "  Type 'shelp' for shortcuts"
fi

# Local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
