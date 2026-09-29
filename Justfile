# https://just.systems

# Show available commands
@_default:
    just --list --list-submodules --unsorted

# Shared setup
@_setup:
    mkdir -p ~/.config

_common := 'bin git lazygit nvim podman shell tmux yazi zsh'
_macos := _common + ' ghostty kitty vscode zed'
_linux := _common
_targets := if os() == 'macos' { _macos } else if os() == 'linux' { _linux } else { error('Unsupported OS: ' + os()) }

# Install dotfiles for the current OS
@stow: _setup
    stow {{ _targets }}

# Autoformat
@fmt:
    just --fmt
    RUST_LOG=warn taplo fmt -o reorder_keys=true herdr/.config/herdr/config.toml

# Setup and install packages with Homebrew
mod brew

# Install fonts
@fonts: _setup
    cd fonts/powerline && ./install.sh
    cd fonts/fontawesome && ./install.sh
    cd fonts/p10k && cp *.ttf ~/Library/Fonts/
    fc-cache

# Rebind macOS keys with hidutil
@rebind-keys:
    pkl eval macos/Library/LaunchAgents/com.local.KeyRemapping.pkl \
        -o macos/Library/LaunchAgents/com.local.KeyRemapping.plist
    launchctl bootout "gui/$(id -u)/com.local.KeyRemapping" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" \
        macos/Library/LaunchAgents/com.local.KeyRemapping.plist
