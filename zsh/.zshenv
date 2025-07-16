#
# Evaluated before ~/.zshrc
#
export DEFAULT_USER=$(whoami)
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export VISUAL=$(which nvim)
export EDITOR="$VISUAL"
export FPP_EDITOR="code"
export MANPAGER="sh -c 'col -bx | bat --plain --theme=\"Monokai Extended Bright\" -l man'";
export MANROFFOPT="-c"
export HISTSIZE=999999
export HISTFILESIZE=999999

# fzf
# See /opt/homebrew/opt/fzf/shell/key-bindings.zsh for docs
#
export FZF_COMPLETION_OPTS='--border --info=inline'                     # Boxy UI
export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix'    # Find files with fd
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix'               # ALT-C - cd into the selected directory
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"                        # CTRL-T - Paste the selected file path(s) to prompt
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"      # Preview Ctrl+T with bat

# homebrew
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1

# rg
export RIPGREP_CONFIG_PATH=~/.ripgreprc

[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

