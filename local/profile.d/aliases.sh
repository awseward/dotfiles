#!/usr/bin/env bash

### general
alias back='cd -'
alias cp='cp -iv'
alias gr='grep -Irisn --color=auto'
alias l='eza -l'
alias ll='eza -la'
alias ln='ln -v'
alias ls='eza -hF --color=auto'
# alias mkdir='mkdir -v'
alias mv='mv -iv'
alias p='ps -a'
alias path='pretty_path'
alias rm='rm -iv'
alias vim='nvim'

### git
alias g='git'
# TODO: Find a better way to detect the "main" branch
alias gm='git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") && git pull origin $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
# # Two shortcomings of this at the moment:
# # - It's super MacOS-specific
# # - The concept of "tee to clipboard" is probably a little more generalizable
# alias pbgb='git rev-parse --abbrev-ref HEAD | tee >(xargs echo -n | pbcopy)'
# alias pbgs='git rev-parse HEAD | tee >(xargs echo -n | pbcopy)'

### hub
alias hc='hub compare'
alias hb='hub browse'

### valgrind
alias val='valgrind'
alias valgrind='valgrind --leak-check=yes'

### ruby
alias be='bundle exec'

### OS-specific
case "$OSTYPE" in
  (darwin*)
    alias rm="rm -dv"
  ;;
  (cygwin*)
    # ...
  ;;
  (linux*)
    # ...
  ;;
esac
