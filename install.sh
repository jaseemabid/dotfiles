#!/usr/bin/env bash

cd "${HOME}/dotfiles"
git pull
# cd "${OLDPWD}"

# Link in files, replacing whatever's already there.
ln -fs "dotfiles/curlrc"				"${HOME}/.curlrc"
ln -fs "dotfiles/gemrc"					"${HOME}/.gemrc"
ln -fs "dotfiles/gitconfig"				"${HOME}/.gitconfig"
ln -fs "dotfiles/gitignore"				"${HOME}/.gitignore"
ln -fs "dotfiles/i3"					"${HOME}/.i3"
ln -fs "dotfiles/i3/i3status.conf"		"${HOME}/.i3status.conf"
ln -fs "dotfiles/latexmkrc"				"${HOME}/.latexmkrc"
ln -fs "dotfiles/rvmrc"					"${HOME}/.rvmrc"
ln -fs "dotfiles/xinitrc"				"${HOME}/.xinitrc"
ln -fs "dotfiles/xscreensaver"			"${HOME}/.xscreensaver"
ln -fs "dotfiles/zprofile"				"${HOME}/.zprofile"
ln -fs "dotfiles/zshrc"					"${HOME}/.zshrc"

# Link in directories, removing whatever's already there first.
# [[ -e "${HOME}/.newsbeuter" ]] && rm -r "${HOME}/.newsbeuter"
# ln -fs ".dotfiles/newsbeuter" "${HOME}/.newsbeuter"

# [[ -e "${HOME}/.terminfo" ]] && rm -r "${HOME}/.terminfo"
# ln -fs ".dotfiles/terminfo" "${HOME}/.terminfo"

# Optionally link in X and Awesome stuff.
# if [[ $1 == "-X" ]]; then
#     ln -fs ".dotfiles/X/Xmodmap"     "${HOME}/.Xmodmap"
#     ln -fs ".dotfiles/X/Xresources"  "${HOME}/.Xresources"
#     ln -fs ".dotfiles/X/xsession"    "${HOME}/.xsession"
#     ln -fs ".dotfiles/X/xsessionrc"  "${HOME}/.xsessionrc"
#     mkdir -p "${HOME}/.config"
#     [[ -e "${HOME}/.config/awesome" ]] && rm -r "${HOME}/.config/awesome"
#     ln -fs "../.dotfiles/awesome" "${HOME}/.config/awesome"
# fi
