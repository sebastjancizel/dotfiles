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
  plugins += (macos brew)
fi

if [[ -n "$SSH_CONNECTION" ]]; then
  # If SSH connection is detected always open a tmux session
  ZSH_TMUX_AUTOSTART=true
fi

source $ZSH/oh-my-zsh.sh

# DEFAULT SETTINGS
export EDITOR=vim #vim ftw
export TERM=xterm-256color

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
