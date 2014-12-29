# -*- mode: shell-script;-*-
# zsh aliases
# Move this file to .oh-my-zsh/custom, not tracked there.
# Author: Jaseem Abid

# System specific aliases
if [[ $OSTYPE == linux-* ]]; then

    # Copy & paste from shell
    alias c='xsel --clipboard --input'
    alias p='xsel --clipboard --output'

	alias open="xdg-open"
	alias o="xdg-open"

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
alias g='git '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias get='git clone '
alias gg='gitg --all'
alias gits='git status '
alias gk='gitk --all&'
alias gl='git log --one-line'
alias go='git checkout '
alias got='git '
alias gs='git status '
alias gt='git '

alias t='tmux'

# Data recovery is a myth
alias dd="echo -e '★★★★★★★★★★★★★★★★★★★★★'; echo -e 'Are you fucking sure?\n'; sleep 7; dd "

# Quickies
alias big="stat -c %s $1"
alias die="xset dpms force off"
alias yt="youtube-dl -twci --console-title"
alias ty="yt"
alias untar="tar -zxvf $1"
alias backup="rsync -avuiWP --delete"
alias ec="emacsclient"
alias record="ffmpeg -f x11grab -r 30 -s 1366x768 -i :0.0 -f alsa -ac 2 -i pulse -vcodec libx264 -acodec pcm_s16le screencast.mkv"
alias ack="/usr/bin/vendor_perl/ack"
alias kil="xset dpms force off"

# Alternatives
alias vi="emacsclient"
alias rm="rm -i"

# Remove trailing whitespace
# http://stackoverflow.com/questions/4438306/removing-trailing-whitespace-with-sed
alias ws='sed -i '\''s/[ \t]*$//'\'' '

alias mousefix='sudo modprobe -r psmouse && sudo modprobe psmouse'

# http://hamberg.no/erlend/posts/2013-01-18-mkcd.html
mkcd () {
    mkdir -p "${1}"
    cd "${1}"
}
alias mkdir="echo Did you mean mkcd\?"
