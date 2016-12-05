echo "Setup brew"

brew update

brew tap caskroom/fonts
brew tap railwaycat/emacsmacport

brew cask install emacs-mac
brew cask install font-fira-code

brew install aspell \
             autoconf \
             diff-so-fancy \
             dirmngr \
             doxygen \
             erlang \
             ffmpeg \
             gdbm \
             git \
             gnupg2 \
             gpg-agent \
             haskell-stack \
             htop \
             jpeg \
             lame \
             libassuan \
             libevent \
             libgcrypt \
             libgpg-error \
             libksba \
             libpng \
             libtiff \
             libusb \
             libusb-compat \
             md5sha1sum \
             memcached \
             mtr \
             mutt \
             openssl \
             pcre \
             pinentry \
             pinentry-mac \
             pkg-config \
             pth \
             python \
             python3 \
             ranger \
             readline \
             sloccount \
             sqlite \
             stow \
             thefuck \
             tig \
             tmux \
             tokyo-cabinet \
             unixodbc \
             utf8proc \
             wget \
             wxmac \
             x264 \
             xvid \
             xz \
             youtube-dl \
             zsh

brew linkapps
