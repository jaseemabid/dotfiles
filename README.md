# dotfiles

ℹ http://dotfiles.github.com

### What's included

Usual suspects. Config for my work Mac, personal laptop running Arch Linux and
the raspberry pi.

1. ZSH with [Oh My ZSH] and [powerlevel9k] theme.
1. Necessary _free_ fonts to get started
1. Spacemacs with a lot of tweaks
1. Tmux, with sane defaults, bars and key bindings

### Installation

Modules are symlinked to where its needed with [GNU Stow].

⚠ _ This will override existing files _

    git clone --recurse-submodules https://github.com/jaseemabid/dotfiles.git ~/dotfiles

Install a single module:

    stow tmux

Docker and arch packages needs to be installed at /

    sudo stow -t / docker

Install everything with Make

    make

### License

The MIT License (MIT)

[powerlevel9k]: https://github.com/bhilburn/powerlevel9k
[Oh My ZSH]: https://github.com/robbyrussell/oh-my-zsh
[GNU Stow]: https://www.gnu.org/software/stow/
