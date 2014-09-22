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
ZSH_THEME="agnoster"

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
    plugins=(git archlinux command-not-found cp systemd )
else
    # Non root users
    # Different config for linux and mac
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        plugins=(git virtualenv virtualenvwrapper)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(git)
    else
        # Unknown, or  cygwin/win32/freebsd*
        echo "GET A LIFE, USE A SENSIBLE OS"
    fi

    # Load virtualenvwrapper only if available
    if [[ -s $(which virtualenvwrapper.sh) ]] ; then

        # Its called python2 on archlinux, python on mac
        if [[ -s $(which python2) ]] ; then
            export VIRTUALENVWRAPPER_PYTHON=$(which python2)
        else
            export VIRTUALENVWRAPPER_PYTHON=$(which python)
        fi

        export WORKON_HOME=$HOME/.virtualenvs
        export PROJECT_HOME=$HOME/Projects
        source $(which virtualenvwrapper.sh)
    fi

    # Load RVM into a shell session *as a function*
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # This loads NVM
    [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
fi

# A bunch of helpers

# Alt-S inserts "sudo " at the start of line:
insert_sudo () {
    zle beginning-of-line; zle -U "sudo "
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

source $ZSH/oh-my-zsh.sh

# Add ~/bin to path
path=($HOME/bin $path)

# Prepend Cabal per user directories to PATH/MANPATH.
if [[ "$OSTYPE" == darwin* ]]; then
  path=($HOME/Library/Haskell/bin(/N) $path)
  manpath=($HOME/Library/Haskell/man(/N) $manpath)
else
  path=($HOME/.cabal/bin(/N) $path)
  manpath=($HOME/.cabal/man(/N) $path)
fi

[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

# Return success if everything went right
return 0
