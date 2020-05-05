# dotfiles

ℹ http://dotfiles.github.com

### What's included

Usual suspects. Config for my work Mac, personal laptop running Arch Linux and
the raspberry pi.

### Installation

Modules are symlinked to where its needed with [GNU Stow].

⚠ _ This will override existing files _

    git clone --recurse-submodules https://github.com/jaseemabid/dotfiles.git ~/dotfiles

Install a single module:

    stow tmux

Docker and arch packages needs to be installed at /

    sudo stow -t / arch

Install everything with Make

    make

### License

The MIT License (MIT)

[GNU Stow]: https://www.gnu.org/software/stow/
