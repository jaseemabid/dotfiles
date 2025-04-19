# -*-sh-*-

# Evaluated after ~/.zshenv

typeset -U path PATH
cdpath=(~/src)
path=(
    ~/bin
    ~/.local/bin
    ~/.cabal/bin
    ~/.cargo/bin
    ~/go/bin

    # Ruby Gems
    /opt/homebrew/lib/ruby/gems/3.3.0/bin

    # 'Optional' brew installations
    /opt/homebrew/opt/sqlite3/bin
    /opt/homebrew/opt/ruby/bin

    # Prefer homebrew versions over system. Ex git, python3
    /opt/homebrew/bin

    $path)

# Skip most of shell setup for dumb terminals and IDEs quit early
if [[ ${VSCODE_RESOLVING_ENVIRONMENT+x} ]] ||
   [[ ${INTELLIJ_ENVIRONMENT_READER+x} ]]; then
    return
fi

# Tmux attach by default only for local, directly interactive sessions
# Exclude ghostty, VSCode, JetBrains shells
if [[ -z "$TMUX" && -z "$SSH_CLIENT" ]] &&
   [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]] &&
   [[ "$VSCODE_INJECTION" != "1" ]] &&
   [[ "$TERM_PROGRAM" != "ghostty" ]]; then
    exec tmux attach
fi

# Setup oh-my-zsh
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"
ZSH=$HOME/.oh-my-zsh

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
        plugins=(sudo tmux z)
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        plugins=(docker fzf git kubectl rust stack sudo tmux z)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(aws asdf brew common-aliases direnv docker fzf git kubectl rbenv rust stack tmux z)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

# Load custom plugins from non std path for simpler stow packages
source ~/.fzf-tab/fzf-tab.plugin.zsh

[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

source $ZSH/oh-my-zsh.sh

# Unsure why this is needed to enable completions for just
autoload -Uz compinit && compinit -C

# A bunch of helpers

# Alt-S inserts "sudo " at the start of line:
insert_sudo () {
    zle beginning-of-line; zle -U "sudo "
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Move aliases to custom file. Its hard to track aliases.zsh inside oh-my-zsh
source ~/.zaliases

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
[[ $EMACS = t ]] && unsetopt zle && PS1='$ '

if [[ $TTY == /dev/tty1 && -z $DISPLAY && -z "$SSH_CLIENT" && -x "$(command -v startx)" ]]; then
    exec startx
fi

# To customize prompt, run `p10k configure` or edit ~/dotfiles/p10k/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Return success if everything went right
true
