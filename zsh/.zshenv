# Universal environment for every zsh process, including `zsh -c`.
# Keep this file minimal, fast, and free of interactive setup; put prompts,
# plugins, command initialization, and interactive-only variables in .zshrc.

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"

# Used by applications in both interactive and non-interactive zsh processes.
export XDG_CONFIG_HOME="$HOME/.config"
