# -*-sh-*-

export DEFAULT_USER=$(whoami)
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export VISUAL=$(which nvim)
export EDITOR="$VISUAL"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HISTSIZE=999999
export HISTFILESIZE=999999

typeset -U path PATH
cdpath=(~/src)
path=(~/bin ~/.local/bin ~/.cabal/bin ~/.cargo/bin $path)

# Skip most of shell setup for dumb terminals and IDEs quit early
if [[ ${VSCODE_RESOLVING_ENVIRONMENT+x} ]] ||
   [[ ${INTELLIJ_ENVIRONMENT_READER+x} ]]; then
    return
fi

# Tmux attach by default only local, directly interactive sessions
if [[ -z $TMUX && -z "$SSH_CLIENT"  ]] &&
  [[ ${TERMINAL_EMULATOR} != "JetBrains-JediTerm" ]] &&
  [[ ${VSCODE_INJECTION} != "1" ]]; then
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
    ZSH_THEME="powerlevel10k/powerlevel10k"
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
        plugins=(aws common-aliases direnv docker fzf fzf-tab git kubectl rbenv rust stack tmux z)
    else
        echo "Unknown OS"
        exit 1
    fi
fi

[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Configure fzf
export FZF_COMPLETION_OPTS='--border --info=inline'         # Boxy UI
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix' # Find files with fd
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix'   # Find files with fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"            # Ctrl+T with fd
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"      # Preview Ctrl+T with bat

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

# To customize prompt, run `p10k configure` or edit ~/dotfiles/p10k/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Return success if everything went right
true
