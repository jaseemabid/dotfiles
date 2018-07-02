#!/bin/env bash

if [ -x "$(which yaourt)" ]; then
    echo "Yaourt installed already"
else
    echo "Installing yaourt"

    cd /tmp && git clone https://aur.archlinux.org/yaourt.git
    cd /tmp/yaourt && makepkg -si
fi

echo "Installing $(wc -l < packages.txt) packages from core"
sudo pacman -S "$(cat packages.txt)"

echo "Installing $(wc -l < aur.txt) packages from aur"
yaourt --noconfirm -S "$(cat aur.txt)"
