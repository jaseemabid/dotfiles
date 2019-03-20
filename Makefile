all:
	@echo ""
	@echo "usage:"
	@echo ""
	@echo "* make dotfiles -- to install dotfiles"
	@echo "* make clean    -- to clean up dotfiles"
	@echo "* make update   -- get latest version from github, install manually"
	@echo ""

# Targets that needs manual installation:
# zsh theme, fonts, iterm2, solarized, brew

common: fonts
	mkdir -p ~/.config

	stow alacritty
	stow bin
	stow curl
	stow spacemacs
	stow git
	stow gpg
	stow haskell
	stow ranger
	stow tmux
	stow zsh

linux: fonts
	mkdir -p ~/.config

	sudo stow -t / arch
	sudo stow -t / docker
	stow codex
	stow ctags
	stow i3
	stow latex

mac:
	stow slate

fonts:
	cd fonts && ./install.sh

update:
	git pull --verbose

.PHONY : all dotfiles fonts clean
