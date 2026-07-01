# https://just.systems

# Show available commands
@_default:
    just -u --list

# Setup and install packages with Homebrew
mod brew

# Targets that need manual installation:
# zsh theme, iterm2, solarized, brew

# Shared setup
@_setup:
    mkdir -p ~/.config

# Install fonts
@fonts: _setup
    cd fonts/powerline && ./install.sh
    cd fonts/fontawesome && ./install.sh
    cd fonts/p10k && cp *.ttf ~/Library/Fonts/
    fc-cache

# Install common dotfiles
common: _setup
    stow bin
    stow curl
    stow dig
    stow ghostty
    stow git
    stow k9s
    stow lazygit
    stow nvim
    stow podman
    stow rg
    stow sqlite
    stow tmux
    stow yazi
    stow zed
    stow zsh

# Install macOS-specific dotfiles
macos: _setup
    stow lazygit
    stow vscode


