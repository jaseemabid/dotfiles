# Path to your oh-my-zsh configuration.
ZSH=~jaseem/.oh-my-zsh

DEFAULT_USER="jaseem"
LC_ALL="en_US.UTF-8"

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
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails archlinux bundler coffee screen command-not-found cp gem github npm systemd)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Load RVM into a shell session *as a function*
[[  -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# This loads NVM
[[  -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

PATH=$HOME/bin:$HOME/Builds/elixir/bin:/usr/local/heroku/bin:$PATH
