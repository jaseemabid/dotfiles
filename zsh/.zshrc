# Interactive shell configuration, loaded after .zshenv.
#
# Prompts, plugins, command initialization, and interactive-only variables.

typeset -U path PATH fpath FPATH

cdpath=(~/src)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/go/bin

    # Prefer homebrew versions over system. Ex git, python3
    /opt/homebrew/bin
    /opt/homebrew/opt/openjdk/bin
    /opt/homebrew/opt/sqlite3/bin

    # System admin path
    /sbin /usr/local/bin /usr/sbin

    $path)

# Skip most shell setup for IDE environment readers.
if [[ ${VSCODE_RESOLVING_ENVIRONMENT+x} ]] ||
   [[ ${INTELLIJ_ENVIRONMENT_READER+x} ]]; then
    return
fi

# Environment used by interactive tools and shell features.
export EDITOR="/opt/homebrew/bin/zed --wait"
export VISUAL="$EDITOR"
export MANPAGER="sh -c 'col -bx | bat --plain --theme=\"Monokai Extended Bright\" -l man'"
export MANROFFOPT="-c"

# Zsh history
setopt HIST_FCNTL_LOCK
export HISTSIZE=999999
export HISTFILESIZE=999999
export SAVEHIST=100000

# fzf
# See /opt/homebrew/opt/fzf/shell/key-bindings.zsh for docs.
export FZF_DEFAULT_OPTS=''
export FZF_COMPLETION_OPTS='--info=inline' # Show the 30/434 info inline
export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix' # Find files with f
export FZF_ALT_C_COMMAND='fd --hidden --type d --strip-cwd-prefix' # ALT-C - cd into the dir
export FZF_CTRL_R_OPTS='--exact' # Fuzzy match is far too noisy for history
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # CTRL-T - Paste the selected files to prompt
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'" # Preview Ctrl+T with bat

# Command-line tool configuration.
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/config
export ZSH_COMPDUMP=~/.cache/zsh/zcompdump-${ZSH_VERSION}
export LESSHISTFILE=~/.cache/less/history
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export AWS_PAGER='jq .'

if [[ "$OSTYPE" == darwin* ]]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

    # Homebrew's dynamic environment setup is intentionally interactive-only.
    eval "$(/opt/homebrew/bin/brew shellenv)"

    export HOMEBREW_BUNDLE_DUMP_NO_CARGO=1
    export HOMEBREW_BUNDLE_DUMP_NO_FLATPAK=1
    export HOMEBREW_BUNDLE_DUMP_NO_GO=1
    export HOMEBREW_BUNDLE_DUMP_NO_KREW=1
    export HOMEBREW_BUNDLE_DUMP_NO_NPM=1
    export HOMEBREW_BUNDLE_DUMP_NO_UV=1
    export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
    export HOMEBREW_BUNDLE_DUMP_NO_WINGET=1
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ENV_HINTS=1
fi

# Auto-attach to tmux in first Ghostty terminal only
# Additional tabs/windows get a plain shell
if [[ -z "$TMUX" ]] &&
   [[ -z "$SSH_CLIENT" ]] &&
   [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    if ! tmux has-session -t main 2>/dev/null; then
        exec tmux new-session -s main -c ~
    elif [[ -z "$(tmux list-clients -t main 2>/dev/null)" ]]; then
        exec tmux attach-session -t main
    fi
fi

# Enable Powerlevel10k instant prompt. This stays after the tmux handoff so a
# Ghostty launch doesn't render a prompt immediately before exec'ing tmux.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Setup oh-my-zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ZSH_DISABLE_COMPFIX="true"
ZSH=$HOME/.config/zsh/oh-my-zsh

# Disable colours from .oh-my-zsh/lib/theme-and-appearance.zsh
DISABLE_LS_COLORS="true"

# Theme setup
if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
    ZSH_THEME="robbyrussell"
else
    source ~/.config/zsh/p10k/powerlevel10k.zsh-theme
fi

# Configure a minimal shell for root user
if [[ $UID = '0' ]]
then
    # Root user
    plugins=()
else
    # Non root users
    if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
        plugins=(eza sudo zoxide)
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        plugins=(common-aliases docker eza fzf git rust stack sudo zoxide)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(brew common-aliases docker eza fzf git rust zoxide)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

# Optional plugins (added if command is available)
(( $+commands[aws] )) && plugins+=(aws)
(( $+commands[kubectl] )) && plugins+=(kubectl)

# Configure eza plugin
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'git-status' no # Way too slow for large repos
zstyle ':omz:plugins:eza' 'color-scale' size
zstyle ':omz:plugins:eza' 'color-scale-mode' gradient
zstyle ':omz:plugins:eza' 'hyperlink' yes
zstyle ':omz:plugins:eza' 'show-group' no
zstyle ':omz:plugins:eza' 'dirs-first' yes

# Load custom plugins from non std path for simpler stow packages
source ~/.config/fzf-tab/fzf-tab.plugin.zsh

for file in ~/.config/zshrc.d/*.zsh(N.); do
    source "$file"
done
unset file

source $ZSH/oh-my-zsh.sh

# A bunch of helpers

# Alt-S inserts "sudo " at the start of line:
insert_sudo () {
    zle beginning-of-line; zle -U "sudo "
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Alt-Z opens zed at the git root (falls back to cwd if not in a repo).
run_zed_at_root() {
    zle push-input
    BUFFER="zed"
    zle accept-line
}
zle -N run-zed-at-root run_zed_at_root
bindkey '^[z' run-zed-at-root

# Alt-G launches lazygit. ^Q stashes the current line and restores it after.
bindkey -s '^[g' '^Qlazygit^M'

# Move aliases to custom file. Its hard to track aliases.zsh inside oh-my-zsh
source ~/.zaliases

# Extend eza plugin aliases with --long and tree variants
if (( $+commands[eza] )); then
    local _base_cmd="${aliases[ls]} --long"
    alias ls="${_base_cmd}"
    alias le="${_base_cmd} --tree --level=1"
    alias lee="${_base_cmd} --tree --level=2"
fi

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
[[ $EMACS = t ]] && unsetopt zle && PS1='$ '

# To customize prompt, run `p10k configure` or edit ~/dotfiles/p10k/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(atuin init zsh)"

# Return success if everything went right
true
