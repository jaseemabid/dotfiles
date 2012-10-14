# -*- mode: shell-script;-*-
# bashrc
# Author: Jaseem Abid
#    _  _      _                                       _     _     _     _  _
#  _| || |_   (_)                                     | |   (_)   | |  _| || |_
# |_  __  _|   _  __ _ ___  ___  ___ _ __ ___     __ _| |__  _  __| | |_  __  _|
#  _| || |_   | |/ _` / __|/ _ \/ _ \ '_ ` _ \   / _` | '_ \| |/ _` |  _| || |_
# |_  __  _|  | | (_| \__ \  __/  __/ | | | | | | (_| | |_) | | (_| | |_  __  _|
#   |_||_|    | |\__,_|___/\___|\___|_| |_| |_|  \__,_|_.__/|_|\__,_|   |_||_|
#            _/ |
#           |__/

# ~/.bashrc: executed by bash(1) for non-login shells.  see
# /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
		color_prompt=yes
    else
		color_prompt=
    fi
fi

# No more motherfucking sytem beeps! Im frustrated already
xset b 50 440 0

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Color definitions.
if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi


# Bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"

# Git bash completion script

if [ -f  ~/bin/git-completion.bash ]; then
	source ~/bin/git-completion.bash
fi

if [[ $EUID -ne 0 ]]; then

	export PS1="\[$bldylw\] \w \[$txtcyn\] [\T \d] \[$txtgrn\] \$(__git_ps1 '[ %s ]' )\n \[$txtrst\] ✈ "
	PATH="~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/.gem/ruby/1.9.1/bin"
else
	export PS1="\[$bldylw\] \w \[$txtcyn\] [\T \d]\[$txtrst\]\n [ROOT] ✈ "
fi

export GEM_HOME="~/.gem/ruby/1.9.1"
