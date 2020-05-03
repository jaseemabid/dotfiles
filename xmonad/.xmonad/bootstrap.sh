#!/bin/bash

if ! type "ghcup" > /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

if ! type "xmobar" > /dev/null; then
    cabal install xmobar --flags="all_extensions"
fi

if ! type "xmonad" > /dev/null; then
    cabal install xmonad --lib
    cabal install xmonad
fi
