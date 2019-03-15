# -*-sh-*-

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

DEFAULT_USER=$(whoami)
export LC_ALL="en_US.UTF-8"

export EDITOR='emacsclient'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH=7
POWERLEVEL9K_VCS_SHORTEN_STRATEGY=truncate_middle

ZSH_THEME="powerlevel9k/powerlevel9k"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting
# for completion
# COMPLETION_WAITING_DOTS="true"

export HISTSIZE=999999
export HISTFILESIZE=999999

# Configure a minimal shell for root user
if [[ $UID = '0' ]]
then
    # Root user
    plugins=()
else
    # Non root users
    if [[ "$OSTYPE" == "linux"* ]]; then
        plugins=(sudo fzf git go stack tmux z rust)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(boot2docker fzf docker kubectl git stack tmux z)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

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

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
[[ $EMACS = t ]] && unsetopt zle && PS1='$ '

[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

if [[ "$OSTYPE" == "linux-gnu" && -z $DISPLAY && -z "$SSH_CLIENT" ]]; then
    exec startx
fi

# Tmux attach by default only local sessions, not for remote ssh
if [[ -z $TMUX && -z "$SSH_CLIENT" ]]; then
    tmux attach
fi

# Return success if everything went right
true
