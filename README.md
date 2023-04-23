# My Dotfiles 🚀✨

This repository contains my personal dotfiles for configuring the shell environment, including the `.zshrc`, `.tmux.conf`, the `install.sh` script for easy setup, and a `Dockerfile` for testing the installation process.

## Prerequisites 🛠

- A Unix-based system (Linux or macOS)
- [Homebrew](https://brew.sh/) (for macOS users)
- Git
- Curl
- Docker (for testing the installation using the Dockerfile)

## Installation Instructions 📝

1. Clone the repository:

```bash
git clone https://github.com/sebastjancizel/dotfiles.git ~/dotfiles
```

2. Change the current directory to the `dotfiles` folder:

```bash
cd ~/dotfiles
```

\**Important**: Make sure you are in the `dotfiles` folder before running the `install.sh` script, as it expects to be run from the repository's root directory.

3. Make the `install.sh` script executable:

```bash
chmod +x install.sh
```

4. Run the `install.sh` script:

```bash
./install.sh
```

The `install.sh` script will install the necessary packages, create symlinks for the `.zshrc` and `.tmux.conf` files in your home directory, and set up your shell environment according to the script's contents. 🎉

**Note**: The script will overwrite your current `.zshrc` and `.tmux.conf` files with symlinks to the ones in the `dotfiles` folder. Make sure to back up your existing configuration files if you don't want to lose them.

## Testing the Installation with Docker 🐳

A `Dockerfile` is included in this repository for testing the installation process in an isolated environment. To test the installation using Docker, follow these steps:

1. Make sure you have Docker installed on your system.

2. Build the Docker image:

```bash
docker build -t my-dotfiles .
```

3. Run the Docker container:

```bash
docker run -it --rm my-dotfiles
```

This will launch an interactive session within the Docker container, where you can test the `install.sh` script and the configuration files.

If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.
