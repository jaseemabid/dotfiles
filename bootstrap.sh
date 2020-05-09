#!/bin/env bash

if [ -x "$(which yay)" ]; then
    echo "Yay installed already"
else
    echo "Installing yay"
    sudo pacman --noconfirm -S git

    sudo pacman --noconfirm -S - < packages.txt
    rm -rf /tmp/yay /tmp/package-query

    cd /tmp && git clone https://aur.archlinux.org/package-query.git
    cd package-query && makepkg -si

    cd /tmp && git clone https://aur.archlinux.org/yay.git
    cd /tmp/yay && makepkg -si
fi

echo "Installing $(wc -l < packages.txt) packages"
yay --noconfirm -S - < packages.txt

