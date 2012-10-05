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
LN = /bin/ln -r
CP = /bin/cp -r

all:
	@echo ""
	@echo "usage:"
	@echo ""
	@echo "* make dotfiles		-- to install dotfiles"
	@echo "* make clean			-- to clean up dotfiles"
	@echo ""

dotfiles:
	$(CP) bash_aliases ~/.bash_aliases
	$(CP) bash_colors ~/.bash_colors
	$(CP) bash_logout ~/.bash_logout
	$(CP) bashrc ~/.bashrc


.PHONY : all dotfiles clean
