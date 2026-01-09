# Dotfiles

Minimal, fast dotfiles for a functional dev environment. Installs tools directly from GitHub releases.

## What's Included

- **Shell**: zsh with [zinit](https://github.com/zdharma-continuum/zinit) (plugin manager) + [Starship](https://starship.rs) prompt
- **Editor**: [Neovim](https://neovim.io) with [LazyVim](https://lazyvim.github.io)
- **Terminal multiplexer**: tmux with [Catppuccin](https://github.com/catppuccin/tmux) theme
- **CLI tools**: fzf, ripgrep, bat, eza (all from GitHub releases)

## Installation

```bash
git clone https://github.com/sebastjancizel/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The installer downloads tools directly from GitHub releases - no Homebrew or apt required for the core tools.

## Structure

```
dotfiles/
├── .zshrc           # Shell config (zinit + starship)
├── .tmux.conf       # Tmux config (catppuccin theme)
├── starship.toml    # Starship prompt config
├── nvim/            # Neovim config (LazyVim-based)
│   └── lua/
│       ├── config/  # Core settings + keymaps
│       └── plugins/ # Custom plugins
└── install.sh       # Installer script
```

## Customization

- **Machine-specific settings**: Create `~/.zshrc.local` (not tracked in git)
- **Neovim plugins**: Add files to `nvim/lua/plugins/`
- **Starship prompt**: Edit `starship.toml`

## Testing with Docker

```bash
docker build -t dotfiles .
docker run -it --rm dotfiles
```
