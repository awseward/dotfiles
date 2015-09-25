#!/bin/zsh

alias ls="ls -hFG"
alias rm="rm -dv"

# Unset open() from ~/.lib/misc.sh
if [[ "$(type open)" =~ 'is a shell function' ]]; then
  unset -f open
fi
