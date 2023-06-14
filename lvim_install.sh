#!/bin/bash

# Function to log messages in cyan
log() {
    echo -e "\033[0;36m$1\033[0m"
}

log "Starting installation..."

# Install basic utilities and Neovim
log "[1/4] Installing basic utilities and Neovim..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update >/dev/null
    sudo apt-get install -y git curl nodejs npm python3-pip >/dev/null
    sudo apt-get install -y neovim >/dev/null
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install git curl node npm python3 neovim >/dev/null
fi

# Upgrade pip (Python package installer)
log "[2/4] Upgrading pip..."
pip3 install --upgrade pip >/dev/null

# Install Neovim Python client
log "[3/4] Installing pynvim..."
pip3 install pynvim >/dev/null

# Install LunarVim
log "[4/4] Installing LunarVim..."
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) >/dev/null

log "Installation complete"

