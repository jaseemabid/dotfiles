# -*-sh-*-

# Evaluated after ~/.zshenv

typeset -U path PATH
cdpath=(~/src)
path=(
    ~/bin
    ~/.local/bin
    ~/.cabal/bin
    ~/.cargo/bin
    ~/.claude/local
    ~/go/bin

    # Prefer homebrew versions over system. Ex git, python3
    /opt/homebrew/bin
    /usr/local/bin

    # Other Optional & Ruby Gems
    /opt/homebrew/lib/ruby/gems/3.3.0/bin
    /opt/homebrew/opt/ruby/bin
    /opt/homebrew/opt/sqlite3/bin

    # System admin path
    /sbin
    /usr/sbin

    $path)

# Homebrew's shell completions aren't in path by default
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Skip most of shell setup for dumb terminals and IDEs quit early
if [[ ${VSCODE_RESOLVING_ENVIRONMENT+x} ]] ||
   [[ ${INTELLIJ_ENVIRONMENT_READER+x} ]]; then
    return
fi

# Tmux session groups for shared windows with independent views
# Exclude VSCode, JetBrains shells, Apple Terminal
if [[ -z "$TMUX" ]] &&
   [[ -z "$SSH_CLIENT" ]] &&
   [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]] &&
   [[ "$VSCODE_INJECTION" != "1" ]] &&
   [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    # Create main session if it doesn't exist, then attach to session group
    tmux has-session -t main 2>/dev/null || tmux new-session -d -s main -c ~
    exec tmux new-session -t main
fi

# Setup oh-my-zsh
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"
ZSH=$HOME/.oh-my-zsh

# Disable colours from .oh-my-zsh/lib/theme-and-appearance.zsh
DISABLE_LS_COLORS="true"

# Theme setup
if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
    ZSH_THEME="robbyrussell"
else
    source ~/.p10k/powerlevel10k.zsh-theme
fi

# Configure a minimal shell for root user
if [[ $UID = '0' ]]
then
    # Root user
    plugins=()
else
    # Non root users
    if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
        plugins=(eza sudo z)
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        plugins=(common-aliases docker eza fzf git rust stack sudo z)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(brew common-aliases direnv docker eza fzf git rust z)
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

[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

source $ZSH/oh-my-zsh.sh

# A bunch of helpers

# Alt-S inserts "sudo " at the start of line:
insert_sudo () {
    zle beginning-of-line; zle -U "sudo "
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

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
