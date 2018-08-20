#!/bin/zsh

echo "Setup brew"

brew update

brew tap caskroom/fonts
brew tap railwaycat/emacsmacport

brew cask install emacs-mac

brew install aspell
brew install automake     # Tool for generating GNU compliant Makefiles
brew install coreutils    # File, shell and text manipulation utilities
brew install cowsay
brew install cdiff        # For side by side diffs, use with a -s
brew install diff-so-fancy
brew install erlang
brew install ffmpeg
brew install git
brew install gnupg
brew install haskell-stack
brew install highlight
brew install htop
brew install jq
brew install mtr
brew install pinentry-mac # So that emacs can ask for pass phrase on mac
brew install python
brew install ranger
brew install reattach-to-user-namespace
brew install stow
brew install the_silver_searcher
brew install tig
brew install tmux
brew install wget
brew install youtube-dl
brew install zsh

brew upgrade
brew cleanup
