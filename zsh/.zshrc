# Interactive shell configuration, loaded after .zshenv.
#
# Prompts, plugins, command initialization, and interactive-only variables.

typeset -U path PATH fpath FPATH

cdpath=(~/src)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.krew/bin
    ~/go/bin

    # Prefer homebrew versions over system. Ex git, python3
    /opt/homebrew/bin
    /opt/homebrew/sbin
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

# FZF. See /opt/homebrew/opt/fzf/shell/key-bindings.zsh for docs.
export FZF_DEFAULT_OPTS=''
export FZF_COMPLETION_OPTS='--info=inline' # Show the 30/434 info inline
export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix' # Find files with f
export FZF_ALT_C_COMMAND='fd --hidden --type d --strip-cwd-prefix' # ALT-C - cd into the dir
export FZF_CTRL_R_OPTS='--exact' # Fuzzy match is far too noisy for history
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # CTRL-T - Paste the selected files to prompt
# Ctrl+T opens fzf; ⌥f files · ⌥d dirs · ⌥g tracked · ⌥c dirty · ⌥e edit · ⌥y yank
export FZF_CTRL_T_OPTS="
  --prompt 'Files> '
  --header '⌥f files · ⌥d dirs · ⌥g tracked · ⌥c dirty · ⌥e edit · ⌥y yank'
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'alt-f:reload(fd --hidden --type f --strip-cwd-prefix | sort)+change-prompt(Files> )'
  --bind 'alt-d:reload(fd --hidden --type d --strip-cwd-prefix | sort)+change-prompt(Dirs> )'
  --bind 'alt-g:reload(git ls-files)+change-prompt(Tracked> )'
  --bind 'alt-c:reload(git status --porcelain | cut -c4-)+change-prompt(Dirty> )'
  --bind 'alt-e:execute-silent(zed {} 2>/dev/null)+abort'
  --bind 'alt-y:execute-silent(echo {} | pbcopy)'"

export RIPGREP_CONFIG_PATH=~/.config/ripgrep/config
export ZSH_COMPDUMP=~/.cache/zsh/zcompdump-${ZSH_VERSION}
export LESSHISTFILE=~/.cache/less/history
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export AWS_PAGER='jq .'

# Auto-attach to tmux in first Ghostty terminal only.
# Do this before tool initialization so a shell replaced by tmux doesn't do that work twice.
if [[ -z "$TMUX" ]] &&
   [[ -z "$SSH_CLIENT" ]] &&
   [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    if ! tmux has-session -t main 2>/dev/null; then
        exec tmux new-session -s main -c ~
    elif [[ -z "$(tmux list-clients -t main 2>/dev/null)" ]]; then
        exec tmux attach-session -t main
    fi
fi

# Render the cached prompt before tool initialization, but after the tmux handoff.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ "$OSTYPE" == darwin* ]]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

    # Homebrew installation paths, without spawning brew on every startup.
    # PATH and fpath are already configured above, with user binaries first.
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
    export HOMEBREW_REPOSITORY=/opt/homebrew

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

# Setup oh-my-zsh
DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true" # Disable colours from .oh-my-zsh/lib/theme-and-appearance.zsh
ZSH=$HOME/.config/zsh/oh-my-zsh
ZSH_DISABLE_COMPFIX="true"
ZSH_THEME="" # Powerlevel10k is loaded directly after OMZ; don't load an OMZ theme.

# Configure a minimal shell for root user
if [[ $UID = '0' ]]
then
    # Root user
    plugins=()
else
    # Non root users
    if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
        plugins=(sudo zoxide)
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        plugins=(docker fzf git rust sudo zoxide)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(brew docker git rust sudo zoxide)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

# Optional plugins (added if command is available)
(( $+commands[aws] )) && plugins+=(aws)
(( $+commands[kubectl] )) && plugins+=(kubectl)

# Zsh glob qualifiers: N allows no matches; . selects regular files.
# shellcheck disable=SC1036,SC1058,SC1072,SC1073
for file in ~/.config/zshrc.d/*.zsh(N.); do
    source "$file"
done
unset file

source $ZSH/oh-my-zsh.sh

# Load Homebrew's fzf scripts directly after compinit (from OMZ).
if [[ "$OSTYPE" == darwin* && $UID != 0 ]]; then
    [[ "$DISABLE_FZF_AUTO_COMPLETION" == true ]] ||
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    [[ "$DISABLE_FZF_KEY_BINDINGS" == true ]] ||
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Load after compinit and fzf so Tab remains bound to fzf-tab.
source ~/.config/fzf-tab/fzf-tab.plugin.zsh

# A bunch of helpers

# Kitty sends Option/Alt+Arrow as modified-arrow sequences. Bind them explicitly
# because terminal multiplexers such as Herdr do not load kitty's zsh integration.
bindkey $'\e[1;3D' backward-word
bindkey $'\e[1;3C' forward-word

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

# eza aliases; omit --git because it's slow in large repositories.
# Keep l (system ls) and ll (yazi) from .zaliases.
if (( $+commands[eza] )); then
    local _eza='eza --group-directories-first --icons=auto --color-scale=size --color-scale-mode=gradient --hyperlink=auto'
    alias ls="$_eza --long"
    alias la="$_eza --long --all"
    alias ldot="$_eza --long --treat-dirs-as-files .*"
    alias lD="$_eza --long --only-dirs"
    alias lDD="$_eza --long --only-dirs --all"
    alias lsd="$_eza --treat-dirs-as-files"
    alias lsdl="$_eza --treat-dirs-as-files --long"
    alias lS="$_eza --long --sort=size"
    alias lT="$_eza --long --sort=newest"
    alias le="$_eza --long --tree --level=1"
    alias lee="$_eza --long --tree --level=2"
    unset _eza
fi

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
[[ $EMACS = t ]] && unsetopt zle && PS1='$ '

# Load settings before the theme so Powerlevel10k starts with our configuration.
# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.config/zsh/p10k/powerlevel10k.zsh-theme

eval "$(atuin init zsh)"

# Disable plain Enter on an empty line.
_accept-line() {
  if [[ -z $BUFFER && $CONTEXT == start ]]; then
    return 0
  fi
  zle .accept-line
}
zle -N accept-line _accept-line

# Return success if everything went right
true
