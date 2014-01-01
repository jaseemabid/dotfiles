#
#    _                               _           _       _    __ _ _
#   (_)                             ( )         | |     | |  / _(_) |
#    _  __ _ ___  ___  ___ _ __ ___ |/ ___    __| | ___ | |_| |_ _| | ___  ___
#   | |/ _` / __|/ _ \/ _ \ '_ ` _ \  / __|  / _` |/ _ \| __|  _| | |/ _ \/ __|
#   | | (_| \__ \  __/  __/ | | | | | \__ \ | (_| | (_) | |_| | | | |  __/\__ \
#   | |\__,_|___/\___|\___|_| |_| |_| |___/  \__,_|\___/ \__|_| |_|_|\___||___/
#  _/ |
# |__/


RM = /bin/rm -r
LN = /usr/bin/ln -fs
CP = /bin/cp -r

all:
	@echo ""
	@echo "usage:"
	@echo ""
	@echo "* make dotfiles -- to install dotfiles"
	@echo "* make clean    -- to clean up dotfiles"
	@echo "* make update   -- get latest version from github, install manually"
	@echo ""

# Link in files, replacing whatever's already there.
dotfiles:
	$(LN) ~/dotfiles/aliases.zsh  ~/.oh-my-zsh/custom/aliases.zsh
	$(LN) ~/dotfiles/curlrc ~/.curlrc
	$(LN) ~/dotfiles/gemrc ~/.gemrc
	$(LN) ~/dotfiles/gitconfig ~/.gitconfig
	$(LN) ~/dotfiles/gitignore ~/.gitignore
	$(LN) ~/dotfiles/i3 ~/.i3
	$(LN) ~/dotfiles/i3/i3status.conf ~/.i3status.conf
	$(LN) ~/dotfiles/latexmkrc ~/.latexmkrc
	$(LN) ~/dotfiles/rvmrc ~/.rvmrc
	$(LN) ~/dotfiles/xinitrc ~/.xinitrc
	$(LN) ~/dotfiles/xscreensaver ~/.xscreensaver
	$(LN) ~/dotfiles/zprofile ~/.zprofile

update:
	git pull --verbose

.PHONY : all dotfiles clean
