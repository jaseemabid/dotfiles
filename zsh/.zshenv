#
# Evaluated before ~/.zshrc
#
export DEFAULT_USER=$(whoami)
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export EDITOR="$(which zed) --wait"
export VISUAL="$EDITOR"
export FPP_EDITOR="zed"
export MANPAGER="sh -c 'col -bx | bat --plain --theme=\"Monokai Extended Bright\" -l man'";
export MANROFFOPT="-c"

# ZSH History
setopt HIST_FCNTL_LOCK
export HISTSIZE=999999
export HISTFILESIZE=999999
export SAVEHIST=100000

# fzf
# See /opt/homebrew/opt/fzf/shell/key-bindings.zsh for docs
#

export FZF_DEFAULT_OPTS=''
export FZF_COMPLETION_OPTS='--info=inline' # Show the 30/434 info inline
export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix' # Find files with f
export FZF_ALT_C_COMMAND='fd --hidden --type d --strip-cwd-prefix' # ALT-C - cd into the selected director
export FZF_CTRL_R_OPTS="--exact" # Fuzzy match is far too noisy for history
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # CTRL-T - Paste the selected file path(s) to prompt
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'" # Preview Ctrl+T with bat

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

export HOMEBREW_BUNDLE_DESCRIBE=1
export HOMEBREW_BUNDLE_DUMP_NO_CARGO=1
export HOMEBREW_BUNDLE_DUMP_NO_GO=1
export HOMEBREW_BUNDLE_DUMP_NO_UV=1
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

# rg
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/config

# Move dotfile clutter out of ~/
export ZSH_COMPDUMP=~/.cache/zsh/zcompdump
export LESSHISTFILE=~/.cache/less/history

# Node, npm and all JS things.
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# Mac Specific
if [[ "$(uname)" == "Darwin" ]]; then
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi

[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

