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

# Uncomment following line if you want red dots to be displayed while waiting for completion
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
	plugins=(git rails archlinux bundler coffee screen command-not-found cp gem
		github npm systemd virtualenv virtualenvwrapper)

	# load virtualenvwrapper.sh
	export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
	export WORKON_HOME=$HOME/.virtualenvs
	export PROJECT_HOME=$HOME/Projects
	source /usr/bin/virtualenvwrapper.sh

	# Load RVM into a shell session *as a function*
	[[  -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

	# This loads NVM
	[[  -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
fi

PATH=$HOME/bin:$HOME/Builds/elixir/bin:/usr/local/heroku/bin:$PATH

source $ZSH/oh-my-zsh.sh
