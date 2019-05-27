# Set env variables here
if [[ "$OSTYPE" == "linux"* ]]; then
    export GOPATH=~/
    path=(~/bin ~/.local/bin ~/.cargo/bin ~/go/bin $path)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    path=(~/bin
          ~/.local/bin
          ~/.cabal/bin
          ~/.cargo/bin
          ~/.gem/ruby/*/bin
          /usr/local/opt/ruby/bin
          /usr/local/lib/ruby/gems/*/bin
          /usr/local/sbin
          /usr/local/opt/texinfo/bin
          $path)
else
    echo "Unknown OS"
    exit 1
fi

cdpath=(~/Work ~/Projects)

[[ -s "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
