# Set env variables here
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export GOPATH=~/go
    path=(~/bin ~/.local/bin ~/.cargo/bin ~/go/bin $path)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    path=(~/bin ~/.local/bin ~/.cargo/bin
          /Applications/Emacs.app/Contents/MacOS/bin
          /Applications/TeX/TeXShop.app/Contents/Resources/TeXShop/bin/tslatexmk
          /Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin
          $path)
else
    echo "Unknown OS"
    exit 1
fi

cdpath=(~/Work ~/Projects)

[[ -s "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
