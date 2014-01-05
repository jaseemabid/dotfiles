# -*- mode: shell-script;-*-
# zsh aliases
# Move this file to .oh-my-zsh/custom, not tracked there.
# Author: Jaseem Abid


# System specific aliases
if [[ "$OSTYPE" == "linux-gnu" ]]; then

    # Copy & paste from shell
    alias c='xsel --clipboard --input'
    alias p='xsel --clipboard --output'

elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias c='pbcopy'
    alias p='pbpaste'

else
    # Unknown, or  cygwin/win32/freebsd*
    echo "GET A LIFE, USE A SENSIBLE OS"
fi

# Listing
alias l='ls'
alias la='ranger'
alias ll='ranger'

# git
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gl='git log --one-line'
alias gk='gitk --all&'
alias gg='gitg --all'
alias got='git '
alias get='git '
alias gits='git status '
alias get='git clone '
alias g='git '

alias t='tmux'

# Data recovery is a myth
alias dd="echo -e '★★★★★★★★★★★★★★★★★★★★★'; echo -e 'Are you fucking sure?\n'; sleep 7; dd "

# Quickies
alias big="stat -c %s $1"
alias athena="ssh b090264cs@athena"
alias die="xset dpms force off"
alias yt="youtube-dl -twci --console-title"
alias ty="yt"
alias hist="cat ~/.bash_history | grep $1"
alias untar="tar -zxvf $1"
alias backup="rsync -avuiWP --delete"
alias log="cat /var/log/messages.log | grep $1"
alias app="ps -e | grep $1"
alias ec="emacsclient"
alias record="ffmpeg -f x11grab -r 30 -s 1366x768 -i :0.0 -f alsa -ac 2 -i pulse -vcodec libx264 -acodec pcm_s16le screencast.mkv"
alias ack="/usr/bin/vendor_perl/ack"
alias n="node-gyp"
alias kil="xset dpms force off"

alias open="xdg-open"
alias o="xdg-open"

# git aliases
alias git-dep="sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev"
alias git-install="sudo make prefix=/usr gitwebdir=/usr/share/gitweb install"

# Alternatives
alias vi="emacsclient"
alias rm="rm -i"

# Remove trailing whitespace
# http://stackoverflow.com/questions/4438306/removing-trailing-whitespace-with-sed
ws='sed -i '\''s/[ \t]*$//'\'' '
