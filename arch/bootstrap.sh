sudo pacman -S $(cat packages.txt)

cd /tmp && git clone https://aur.archlinux.org/yaourt.git
cd /tmp/yaourt && makepkg -si

