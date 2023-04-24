#!/bin/bash

# Function to log messages in cyan
log() {
    echo -e "\033[0;36m$1\033[0m"
}

log "Starting installation..."

# Set the home directory
HOME_DIR=$HOME

# Install basic utilities
log "[1/6] Installing basic utilities..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update >/dev/null
    sudo apt-get install -y git curl vim tmux sudo tree fd-find ripgrep silversearcher-ag bat zsh >/dev/null
    # Create a symlink to make bat accessible with the bat command
    sudo ln -s /usr/bin/batcat /usr/bin/bat >/dev/null
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install git curl vim tmux tree fd ripgrep the_silver_searcher bat zsh >/dev/null
fi

# Install Oh My Zsh
log "[2/6] Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null

# Set ZSH environment variable
ZSH="$HOME_DIR/.oh-my-zsh"

# Create symlinks for .zshrc and .tmux.conf in the home directory (assuming they are in the same directory as this script)
log "[3/6] Creating symlinks..."
ln -sf "$(pwd)/.zshrc" $HOME_DIR/.zshrc
ln -sf "$(pwd)/.tmux.conf" $HOME_DIR/.tmux.conf
ln -sf "$(pwd)/.p10k.zsh" $HOME_DIR/.p10k.zsh

# Install fzf
log "[4/6] Installing fzf..."
git clone --depth 1 --quiet https://github.com/junegunn/fzf.git $HOME_DIR/.fzf
$HOME_DIR/.fzf/install --all >/dev/null

# Install zsh plugins
log "[5/6] Installing zsh plugins..."
log "=>Cloning powerlevel10k"
git clone --depth=1 --quiet https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k
log "=>Cloning zsh-autosuggestions"
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions
log "=>Cloning zsh-history-substring-search"
git clone --quiet https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-history-substring-search
log "=>Cloning zsh-syntax-highlighting"
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting
log "=>Cloning fzf-tab"
git clone --quiet https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$ZSH/custom}/plugins/fzf-tab

log "[6/6] Installation complete"
