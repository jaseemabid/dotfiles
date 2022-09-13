# dotfiles

ℹ http://dotfiles.github.com

### Installation

    brew install stow
    git clone --recurse-submodules https://github.com/jaseemabid/dotfiles.git ~/dotfiles

Install a single module:

    stow tmux

Docker and arch packages needs to be installed at /

    sudo stow -t / arch

Install everything with Make

    make

### License

The MIT License (MIT)
