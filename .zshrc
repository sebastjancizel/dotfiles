ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

DEFAULT_USER=`whoami`

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins=(
  tmux
  git       # good shortcuts for git
  z         # navigate faster with z 
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

if [[ `uname` == "Darwin" ]]; then
  plugins+=(macos brew)
fi

if [[ -n "$SSH_CONNECTION" ]]; then
  # If SSH connection is detected always open a tmux session
  ZSH_TMUX_AUTOSTART=true
fi

source $ZSH/oh-my-zsh.sh

# DEFAULT SETTINGS
export EDITOR=vim #vim ftw
export TERM=xterm-256color
export TERMINFO=/usr/share/terminfo

# FZF CONFIG
export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git'"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"

ff(){
    fzf --height 80% --layout reverse --info inline --border --preview 'bat --color "always" {}'
}

fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}


# Aliases
alias tmux="tmux -u"
alias gfu="git fetch upstream"
if command -v eza &> /dev/null; then
  # if eza is installed alias ls to eza
  alias ls="eza"
fi

gch() {
  if [ $# -eq 0 ]
  then
    git branch | fzf | xargs -I {} git checkout {};
  else
    git branch | fzf -q "$1" | xargs -I {} git checkout {};
  fi
}

alias zshconfig="vim ~/.zshrc"
alias chrome="Open -a 'Google Chrome'"
alias sshconf="vim ~/.ssh/config"
alias mm="micromamba"

# Update path
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/opt/homebrew/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/sebastjancizel/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

source ~/.profile
mm activate

. "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
