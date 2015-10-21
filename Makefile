#
#    _                               _           _       _    __ _ _
#   (_)                             ( )         | |     | |  / _(_) |
#    _  __ _ ___  ___  ___ _ __ ___ |/ ___    __| | ___ | |_| |_ _| | ___  ___
#   | |/ _` / __|/ _ \/ _ \ '_ ` _ \  / __|  / _` |/ _ \| __|  _| | |/ _ \/ __|
#   | | (_| \__ \  __/  __/ | | | | | \__ \ | (_| | (_) | |_| | | | |  __/\__ \
#   | |\__,_|___/\___|\___|_| |_| |_| |___/  \__,_|\___/ \__|_| |_|_|\___||___/
#  _/ |
# |__/

RM = /bin/rm -rf
LN = /bin/ln -Tfs
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
	$(LN) ~/dotfiles/curlrc ~/.curlrc
	$(LN) ~/dotfiles/emacs.d ~/.emacs.d
	$(LN) ~/dotfiles/gemrc ~/.gemrc
	$(LN) ~/dotfiles/gitconfig ~/.gitconfig
	$(LN) ~/dotfiles/gitignore ~/.gitignore
	$(LN) ~/dotfiles/jsbeautifyrc ~/.jsbeautifyrc
	$(LN) ~/dotfiles/latexmkrc ~/.latexmkrc
	$(LN) ~/dotfiles/oh-my-zsh ~/.oh-my-zsh
	$(LN) ~/dotfiles/aliases.zsh  ~/.oh-my-zsh/custom/aliases.zsh
	$(LN) ~/dotfiles/rvmrc ~/.rvmrc
	$(LN) ~/dotfiles/screenrc ~/.screenrc
	$(LN) ~/dotfiles/slate ~/.slate
	$(LN) ~/dotfiles/tmux.conf ~/.tmux.conf
	$(LN) ~/dotfiles/xinitrc ~/.xinitrc
	$(LN) ~/dotfiles/xscreensaver ~/.xscreensaver
	$(LN) ~/dotfiles/zprofile ~/.zprofile
	$(LN) ~/dotfiles/zshrc ~/.zshrc

bin-files:
	mkdir -p ~/bin
	$(LN) ~/dotfiles/bin/git-cal ~/bin/git-cal
	$(LN) ~/dotfiles/bin/imdbtool.py ~/bin/imdbtool.py
	$(LN) ~/dotfiles/bin/notify ~/bin/notify
	$(LN) ~/dotfiles/bin/player-sync ~/bin/player-sync
	$(LN) ~/dotfiles/bin/today ~/bin/today
	$(LN) ~/dotfiles/bin/wireless.sh ~/bin/wireless.sh

i3:
	$(RM) ~/.i3
	$(LN) ~/dotfiles/i3 ~/.i3
	$(LN) ~/dotfiles/i3/i3status.conf ~/.i3status.conf

fonts:
	cd fonts
	./install.sh

update:
	git pull --verbose

.PHONY : all bin-files i3 dotfiles clean
