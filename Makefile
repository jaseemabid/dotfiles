#
#    _                               _           _       _    __ _ _
#   (_)                             ( )         | |     | |  / _(_) |
#    _  __ _ ___  ___  ___ _ __ ___ |/ ___    __| | ___ | |_| |_ _| | ___  ___
#   | |/ _` / __|/ _ \/ _ \ '_ ` _ \  / __|  / _` |/ _ \| __|  _| | |/ _ \/ __|
#   | | (_| \__ \  __/  __/ | | | | | \__ \ | (_| | (_) | |_| | | | |  __/\__ \
#   | |\__,_|___/\___|\___|_| |_| |_| |___/  \__,_|\___/ \__|_| |_|_|\___||___/
#  _/ |
# |__/


# [todo] - Install dependencies, like oh-my-zsh, emacs.d before installation
# [fix] - Nested links for i3, emacs.d etc on subsequent runs
# [todo] - Reduce redundancy. Loop over an array?
# [todo] - Copy fonts
# [todo] - Get rm, ln .. paths from env

RM = /bin/rm -rf
LN = /bin/ln -fs
CP = /bin/cp -r

all:
	@echo ""
	@echo "usage:"
	@echo ""
	@echo "* make dotfiles -- to install dotfiles"
	@echo "* make clean    -- to clean up dotfiles"
	@echo "* make update   -- get latest version from github, install manually"
	@echo ""

# Link in files, replacing whatever is already there.
# [todo] - Fix dependency on `~/dotfiles` path
dotfiles: bin-files i3 oh-my-zsh emacs.d
	$(LN) ~/dotfiles/aliases.zsh  ~/.oh-my-zsh/custom/aliases.zsh
	$(LN) ~/dotfiles/curlrc ~/.curlrc
	$(LN) ~/dotfiles/gemrc ~/.gemrc
	$(LN) ~/dotfiles/gitconfig ~/.gitconfig
	$(LN) ~/dotfiles/gitignore ~/.gitignore
	$(LN) ~/dotfiles/jsbeautifyrc ~/.jsbeautifyrc
	$(LN) ~/dotfiles/latexmkrc ~/.latexmkrc
	$(LN) ~/dotfiles/rvmrc ~/.rvmrc
	$(LN) ~/dotfiles/screenrc ~/.screenrc
	$(LN) ~/dotfiles/tmux.conf ~/.tmux.conf
	$(LN) ~/dotfiles/xinitrc ~/.xinitrc
	$(LN) ~/dotfiles/xscreensaver ~/.xscreensaver
	$(LN) ~/dotfiles/zshrc ~/.zshrc
	$(LN) ~/dotfiles/zprofile ~/.zprofile

bin-files:
	mkdir -p ~/bin
	$(LN) ~/dotfiles/bin/git-cal ~/bin
	$(LN) ~/dotfiles/bin/imdbtool.py ~/bin
	$(LN) ~/dotfiles/bin/notify ~/bin
	$(LN) ~/dotfiles/bin/player-sync ~/bin
	$(LN) ~/dotfiles/bin/today ~/bin
	$(LN) ~/dotfiles/bin/wireless.sh ~/bin

oh-my-zsh:
	# [fix] - Don't lock down OMZ to old revision
	git clone https://github.com/robbyrussell/oh-my-zsh.git
	cd oh-my-zsh
	git reset --hard d6a36b175646fa2a79466f050b07d47c2342b75e
	cd ..
	$(LN) ~/dotfiles/oh-my-zsh ~/.oh-my-zsh

i3:
	$(RM) ~/.i3
	$(LN) ~/dotfiles/i3 ~/.i3
	$(LN) ~/dotfiles/i3/i3status.conf ~/.i3status.conf

emacs.d:
	git clone https://github.com/jaseemabid/emacs.d.git
	$(LN) ~/dotfiles/emacs.d ~/.emacs.d

update:
	git pull --verbose

.PHONY : all bin-files i3 dotfiles clean
