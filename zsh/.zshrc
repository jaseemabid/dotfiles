# -*-sh-*-

DEFAULT_USER=$(whoami)

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export VISUAL='/usr/local/bin/nvim'
export EDITOR="$VISUAL"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Skip most of shell setup for dumb terminals and IDEs
if [[ ${INTELLIJ_ENVIRONMENT_READER+x} ]]; then
    echo "SHELL?, should probably quit"
    exit 0
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh configuration.
ZSH_DISABLE_COMPFIX="true"
ZSH=$HOME/.oh-my-zsh

# Theme setup
if [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
    ZSH_THEME="robbyrussell"
else
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

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

cdpath=(~/src)
path=(~/bin ~/.local/bin ~/.cabal/bin ~/.cargo/bin $path)

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
        plugins=(cargo docker fzf git kubectl rust stack sudo tmux z)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        plugins=(cargo docker fzf git kubectl rbenv rust stack tmux z)
        path=(/opt/brew/bin /usr/local/opt/ruby/bin /usr/local/sbin /usr/local/opt/texinfo/bin $path)
        [[ -d /opt/brew/share/zsh/site-functions/ ]] && fpath+=(/opt/brew/share/zsh/site-functions/)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

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

# Make sure tramp wont blow up
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
[[ $EMACS = t ]] && unsetopt zle && PS1='$ '

if [[ $TTY == /dev/tty1 && -z $DISPLAY && -z "$SSH_CLIENT" && -x "$(command -v startx)" ]]; then
    exec startx
fi

# Tmux attach by default only local sessions, not for remote ssh
if [[ -z $TMUX && -z "$SSH_CLIENT" ]]; then
    exec tmux attach
fi

# To customize prompt, run `p10k configure` or edit ~/dotfiles/p10k/.p10k.zsh.
[[ ! -f ~/dotfiles/p10k/.p10k.zsh ]] || source ~/dotfiles/p10k/.p10k.zsh

# Return success if everything went right
true
