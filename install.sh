#!/bin/bash

set -e
# Function to log messages in cyan
log() {
	echo -e "\033[0;36m$1\033[0m"
}

log "Starting installation..."

export PATH="$HOME/.local/bin:$PATH"
# Check if HOME_DIR is set else set it to $HOME
# This allows the user to pass a custom home directory as an environment variable
if [ -z "$HOME_DIR" ]; then
	HOME_DIR=$HOME
fi

# Install basic utilities
log "[1/7] Installing basic utilities..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt update >/dev/null
	export DEBIAN_FRONTEND=noninteractive
	sudo apt install -yq dialog git curl vim tmux sudo python3 python3-pip build-essential make file 1>/dev/null
	sudo apt install -yq ninja-build gettext unzip 1>/dev/null
	sudo apt install -yq fd-find ripgrep silversearcher-ag bat zsh exa tree 1>/dev/null
	# Create a symlink to make bat accessible with the bat command
	sudo ln -s /usr/bin/batcat /usr/bin/bat >/dev/null
	pip3 install cmake
elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install git curl vim tmux tree fd ripgrep the_silver_searcher bat zsh git-delta cmake ninja pipx eza 1>/dev/null
fi

# Install neovim
log "[2/7] Installing neovim from source..."
git clone https://github.com/neovim/neovim --branch nightly --depth 1 --quiet
pushd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo 1>/dev/null
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	pushd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb 1>/dev/null
	popd >/dev/null
elif [[ "$OSTYPE" == "darwin"* ]]; then
	sudo make install 1>/dev/null
fi
popd

# Install Oh My Zsh
log "[3/7] Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null

# Set ZSH environment variable
ZSH="$HOME_DIR/.oh-my-zsh"

# Create symlinks for .zshrc and .tmux.conf in the home directory (assuming they are in the same directory as this script)
log "[4/7] Creating symlinks..."
ln -sf "$(pwd)/.zshrc" "$HOME_DIR/.zshrc"
ln -sf "$(pwd)/.tmux.conf" "$HOME_DIR/.tmux.conf"
ln -sf "$(pwd)/.p10k.zsh" "$HOME_DIR/.p10k.zsh"

mkdir -p "$HOME_DIR/.config/nvim"
ln -sf "$(pwd)/nvim" "$HOME_DIR/.config"

# Install fzf
log "[5/7] Installing fzf..."
git clone --depth 1 --quiet https://github.com/junegunn/fzf.git $HOME_DIR/.fzf
$HOME_DIR/.fzf/install --all >/dev/null

# Install zsh plugins
log "[6/7] Installing zsh plugins..."
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

log "[7/7] Installation complete"
