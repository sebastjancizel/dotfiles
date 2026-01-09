#!/bin/bash
set -e

# Minimal dotfiles installer - uses GitHub releases where possible

log() { echo -e "\033[0;36m$1\033[0m"; }
err() { echo -e "\033[0;31m$1\033[0m" >&2; }

HOME_DIR="${HOME_DIR:-$HOME}"
LOCAL_BIN="$HOME_DIR/.local/bin"
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

OS="$(uname -s)"
ARCH="$(uname -m)"

# Normalize architecture names
case "$ARCH" in
  x86_64) ARCH_ALT="amd64"; ARCH_RUST="x86_64" ;;
  aarch64|arm64) ARCH_ALT="arm64"; ARCH_RUST="aarch64" ;;
  *) err "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Helper to get latest GitHub release tag
gh_latest() {
  curl -sL "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/'
}

# Helper to download and extract from GitHub
gh_download() {
  local url="$1" dest="$2"
  log "  Downloading: $url"
  curl -sL "$url" -o "$dest"
}

# ============================================================================
# 1. System packages (minimal - only what we can't get from GitHub)
# ============================================================================
log "[1/6] Installing system dependencies..."
if [[ "$OS" == "Linux" ]]; then
  if command -v apt &>/dev/null; then
    sudo apt update -qq
    sudo apt install -yqq git curl zsh build-essential
  fi
elif [[ "$OS" == "Darwin" ]]; then
  # Xcode CLI tools provide git, curl, etc.
  xcode-select --install 2>/dev/null || true
fi

# ============================================================================
# 2. Neovim (from GitHub releases)
# ============================================================================
log "[2/6] Installing Neovim..."
NVIM_VERSION=$(gh_latest "neovim/neovim")
if [[ "$OS" == "Linux" ]]; then
  NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${ARCH}.tar.gz"
  gh_download "$NVIM_URL" /tmp/nvim.tar.gz
  tar -xzf /tmp/nvim.tar.gz -C /tmp
  cp -r /tmp/nvim-linux-${ARCH}/* "$HOME_DIR/.local/"
  rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-${ARCH}
elif [[ "$OS" == "Darwin" ]]; then
  NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-macos-${ARCH_ALT}.tar.gz"
  gh_download "$NVIM_URL" /tmp/nvim.tar.gz
  tar -xzf /tmp/nvim.tar.gz -C /tmp
  cp -r /tmp/nvim-macos-${ARCH_ALT}/* "$HOME_DIR/.local/"
  rm -rf /tmp/nvim.tar.gz /tmp/nvim-macos-${ARCH_ALT}
fi
log "  Neovim $NVIM_VERSION installed"

# ============================================================================
# 3. Starship prompt (from GitHub releases)
# ============================================================================
log "[3/6] Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$LOCAL_BIN"
log "  Starship installed"

# ============================================================================
# 4. FZF (from GitHub releases)
# ============================================================================
log "[4/6] Installing fzf..."
FZF_VERSION=$(gh_latest "junegunn/fzf")
FZF_VERSION_NUM="${FZF_VERSION#v}"
if [[ "$OS" == "Linux" ]]; then
  FZF_URL="https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION_NUM}-linux_${ARCH_ALT}.tar.gz"
elif [[ "$OS" == "Darwin" ]]; then
  FZF_URL="https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION_NUM}-darwin_${ARCH_ALT}.tar.gz"
fi
gh_download "$FZF_URL" /tmp/fzf.tar.gz
tar -xzf /tmp/fzf.tar.gz -C "$LOCAL_BIN"
rm /tmp/fzf.tar.gz

# Install fzf shell integration
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME_DIR/.fzf" 2>/dev/null || true
"$HOME_DIR/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
log "  fzf $FZF_VERSION installed"

# ============================================================================
# 5. CLI tools from GitHub releases
# ============================================================================
log "[5/6] Installing CLI tools (ripgrep, bat, eza)..."

# Ripgrep
RG_VERSION=$(gh_latest "BurntSushi/ripgrep")
RG_VERSION_NUM="${RG_VERSION#v}"
if [[ "$OS" == "Linux" ]]; then
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION_NUM}-${ARCH_RUST}-unknown-linux-musl.tar.gz"
elif [[ "$OS" == "Darwin" ]]; then
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION_NUM}-${ARCH_RUST}-apple-darwin.tar.gz"
fi
gh_download "$RG_URL" /tmp/rg.tar.gz
tar -xzf /tmp/rg.tar.gz -C /tmp
cp /tmp/ripgrep-*/rg "$LOCAL_BIN/"
rm -rf /tmp/rg.tar.gz /tmp/ripgrep-*
log "  ripgrep $RG_VERSION installed"

# Bat
BAT_VERSION=$(gh_latest "sharkdp/bat")
BAT_VERSION_NUM="${BAT_VERSION#v}"
if [[ "$OS" == "Linux" ]]; then
  BAT_URL="https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION_NUM}-${ARCH_RUST}-unknown-linux-musl.tar.gz"
elif [[ "$OS" == "Darwin" ]]; then
  BAT_URL="https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION_NUM}-${ARCH_RUST}-apple-darwin.tar.gz"
fi
gh_download "$BAT_URL" /tmp/bat.tar.gz
tar -xzf /tmp/bat.tar.gz -C /tmp
cp /tmp/bat-*/bat "$LOCAL_BIN/"
rm -rf /tmp/bat.tar.gz /tmp/bat-*
log "  bat $BAT_VERSION installed"

# Eza
EZA_VERSION=$(gh_latest "eza-community/eza")
EZA_VERSION_NUM="${EZA_VERSION#v}"
if [[ "$OS" == "Linux" ]]; then
  EZA_URL="https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${ARCH_RUST}-unknown-linux-musl.tar.gz"
elif [[ "$OS" == "Darwin" ]]; then
  EZA_URL="https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${ARCH_RUST}-apple-darwin.tar.gz"
fi
gh_download "$EZA_URL" /tmp/eza.tar.gz
tar -xzf /tmp/eza.tar.gz -C "$LOCAL_BIN"
rm /tmp/eza.tar.gz
log "  eza $EZA_VERSION installed"

# ============================================================================
# 6. Node.js via fnm (Fast Node Manager)
# ============================================================================
log "[6/8] Installing fnm and Node.js..."
FNM_VERSION=$(gh_latest "Schniz/fnm")
if [[ "$OS" == "Linux" ]]; then
  FNM_URL="https://github.com/Schniz/fnm/releases/download/${FNM_VERSION}/fnm-linux.zip"
elif [[ "$OS" == "Darwin" ]]; then
  FNM_URL="https://github.com/Schniz/fnm/releases/download/${FNM_VERSION}/fnm-macos.zip"
fi
gh_download "$FNM_URL" /tmp/fnm.zip
unzip -o /tmp/fnm.zip -d "$LOCAL_BIN"
chmod +x "$LOCAL_BIN/fnm"
rm /tmp/fnm.zip

# Install latest LTS Node
eval "$("$LOCAL_BIN/fnm" env)"
"$LOCAL_BIN/fnm" install --lts
log "  fnm + Node.js LTS installed"

# ============================================================================
# 7. AI Coding Agents
# ============================================================================
log "[7/8] Installing AI coding agents..."

# Claude Code
log "  Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# Amp
log "  Installing Amp..."
npm install -g @anthropic-ai/amp

# Gemini CLI (optional)
npm install -g @google/generative-ai 2>/dev/null || log "  Gemini CLI not available"

log "  AI agents installed"

# ============================================================================
# 8. Symlinks and configuration
# ============================================================================
log "[8/8] Creating symlinks..."
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME_DIR/.tmux.conf"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME_DIR/.config/starship.toml"

mkdir -p "$HOME_DIR/.config"
ln -sf "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"

log "Installation complete!"
log ""
log "Next steps:"
log "  1. Restart your shell or run: exec zsh"
log "  2. Open nvim to let LazyVim install plugins"
log "  3. Run 'tmux' and press prefix + I to install tmux plugins"
