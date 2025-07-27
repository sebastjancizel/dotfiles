# ============================================================================
#  ~/.zshrc  –  portable, documented, self-contained
# ============================================================================
# A cross-platform zsh configuration that works on macOS, Linux, and other
# Unix-like systems. Automatically detects available tools and adjusts
# configuration accordingly.
#
# External dependencies (install via package manager):
# - oh-my-zsh: framework for managing zsh configuration
# - powerlevel10k: theme for oh-my-zsh
# - fzf: command-line fuzzy finder
# - ripgrep (rg): fast text search tool
# - bat: cat clone with syntax highlighting
# - tree: directory listing in tree format
# - eza: modern replacement for ls (optional)

# ------------------------
# 0. Early path helpers
# ------------------------
# Helper function to safely add directories to PATH
path_add() { 
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

# ------------------------
# 1. Platform detection
# ------------------------
IS_MACOS=false
IS_LINUX=false
case "$(uname)" in
  Darwin) IS_MACOS=true ;;
  Linux)  IS_LINUX=true ;;
esac

# ------------------------
# 2. Oh-My-Zsh & Theme setup
# ------------------------
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
if [[ -d "$ZSH" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
  DEFAULT_USER=$(whoami)
else
  echo "⚠️  Oh-My-Zsh directory not found at $ZSH – prompt will be basic."
fi

# Load powerlevel10k configuration if available
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ------------------------
# 3. Plugin configuration
# ------------------------
# Base plugins that work across all platforms
plugins=(
  git                           # Git shortcuts and status info
  tmux                         # Tmux integration
  fzf                          # Fuzzy finder integration
  fzf-tab                      # Replace tab completion with fzf
  z                            # Jump to frequently used directories
  zsh-autosuggestions          # Suggest commands based on history
  zsh-syntax-highlighting      # Syntax highlighting for commands
  zsh-history-substring-search # History search with substring matching
)

# Add platform-specific plugins
if $IS_MACOS; then
  plugins+=(macos brew)        # macOS and Homebrew specific commands
elif $IS_LINUX; then
  plugins+=(sudo systemd)      # Linux-specific tools
fi

# Auto-start tmux when connected via SSH (useful for remote development)
if [[ -n "$SSH_CONNECTION" ]]; then
  ZSH_TMUX_AUTOSTART=true
fi

# Load Oh-My-Zsh if available
[[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"

# ------------------------
# 4. Basic environment setup
# ------------------------
export EDITOR=${EDITOR:-vim}
export TERM=xterm-256color

# Set TERMINFO only if the directory exists (common on Linux)
[[ -d /usr/share/terminfo ]] && export TERMINFO=/usr/share/terminfo

# ------------------------
# 5. FZF configuration
# ------------------------
# Default command: use ripgrep to find files, excluding .git directories
export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git'"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"

# Enhanced file finder with preview using bat
ff() {
  fzf --height 80% --layout=reverse --info=inline --border \
      --preview 'bat --color=always {}'
}

# Find in files: search for text within files and preview matches
fif() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: fif <search_term>"
    echo "Find files containing the search term and preview matches"
    return 1
  fi
  rg --files-with-matches --no-messages "$1" | \
    fzf --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Custom completion for fzf with different previews per command
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# Load fzf shell integration if available
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ------------------------
# 6. Aliases and functions
# ------------------------
# General aliases
alias tmux='tmux -u'                    # Force UTF-8 support in tmux
alias gfu='git fetch upstream'          # Fetch from upstream remote
alias zshconfig="$EDITOR ~/.zshrc"      # Quick edit of zsh config
alias sshconf="$EDITOR ~/.ssh/config"   # Quick edit of SSH config


# Enhanced ls with eza if available (modern ls replacement)
if command -v eza &> /dev/null; then
  alias ls='eza'
fi

# macOS-specific aliases
if $IS_MACOS; then
  alias chrome='open -a "Google Chrome"'
fi

# Git branch checkout with fzf integration
gch() {
  if [[ $# -eq 0 ]]; then
    # No arguments: show all branches
    git branch | fzf | xargs -I {} git checkout {}
  else
    # With argument: filter branches by query
    git branch | fzf -q "$1" | xargs -I {} git checkout {}
  fi
}

# ------------------------
# 7. Language toolchains and development tools
# ------------------------

## 7.1 Ruby environment (rbenv)
if command -v rbenv >/dev/null 2>&1; then
  path_add "$HOME/.rbenv/bin"
  eval "$(rbenv init - zsh)"
fi



## 7.2 Rust toolchain
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Ensure user-local binaries are available
path_add "$HOME/.local/bin"

# ------------------------
# 8. Local customization and profiles
# ------------------------
# Source additional shell profiles
[[ -f ~/.profile ]] && source ~/.profile

# Local customizations (machine-specific, never committed to git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Modular configuration directory (for organized custom scripts)
for config_file in ~/.zshrc.d/*.zsh(N); do
  [[ -r "$config_file" ]] && source "$config_file"
done

# ============================================================================
#  Configuration complete
# ============================================================================
# To customize this configuration:
# 1. Add machine-specific settings to ~/.zshrc.local
# 2. Add modular configurations to ~/.zshrc.d/name.zsh
# 3. Install missing tools via your package manager:
#    - macOS: brew install ripgrep fzf bat tree eza
#    - Ubuntu: apt install ripgrep fzf bat tree
#    - Arch: pacman -S ripgrep fzf bat tree eza
