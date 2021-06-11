#!/usr/bin/env bash

### general
alias back='cd -'
alias cp='cp -iv'
alias gr='grep -Irisn --color=auto'
alias hk='heroku'
alias l='exa -l'
alias ll='exa -la'
alias ln='ln -v'
alias ls='ls -hF --color=auto'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias p='ps -a'
alias path='pretty_path'
alias rm='rm -Iv'

### git
alias g='git'
# TODO: Find a better way to detect the "main" branch
alias gm='git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") && git pull origin $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
# Two shortcomings of this at the moment:
# - It's super MacOS-specific
# - The concept of "tee to clipboard" is probably a little more generalizable
alias pbgb='git rev-parse --abbrev-ref HEAD | tee >(pbcopy)'
alias pbgs='git rev-parse HEAD | tee >(pbcopy)'

### hub
alias hc='hub compare'
alias hb='hub browse'

### make
alias m='make clean && make'
alias mc='make clean'

### valgrind
alias val='valgrind'
alias valgrind='valgrind --leak-check=yes'

### rcm
alias mkrc='mkrc -v'
alias rcdn='rcdn -v'
alias rcup='rcup -v'

### ruby
alias be='bundle exec'

### OS-specific
case "$OSTYPE" in
  (darwin*)
    alias ls="ls -hFG"
    alias rm="rm -dv"
  ;;
  (cygwin*)
    # ...
  ;;
  (linux*)
    # ...
  ;;
esac
