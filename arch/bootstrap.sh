#!/bin/env bash

echo "Installing $(wc -l < packages.txt) packages from core"
sudo pacman --noconfirm -S - < packages.txt

if [ -x "$(which yaourt)" ]; then
    echo "Yaourt installed already"
else
    echo "Installing yaourt"

    rm -rf /tmp/yaourt
    cd /tmp && git clone https://aur.archlinux.org/yaourt.git
    cd /tmp/yaourt && makepkg -si
fi

echo "Installing $(wc -l < aur.txt) packages from aur"
yaourt --noconfirm -S - < aur.txt
