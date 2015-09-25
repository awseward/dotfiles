#!/bin/zsh

__git_parse_remote_host_http() {
  echo "$1" | sed -E 's/.*\:\/\/(.+\.[^/]+)\/.*/\1/'
}

__git_parse_remote_host_ssh() {
  echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\1/g'
}

__git_parse_remote_owner_http() {
  echo "$1" | sed -E 's/.*\:\/\/.*\/(.+)\/.*/\1/'
}

__git_parse_remote_owner_ssh() {
  echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\2/g'
}

__git_parse_remote_name_http() {
  echo "$1" | sed -E 's/.*\/(.+)$/\1/ ; s/\.git$//'
}

__git_parse_remote_name_ssh() {
  echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\3/g'
}

alias ls="ls -hFG"
alias rm="rm -dv"

# Unset open() from ~/.lib/misc.sh
if [[ "$(type open)" =~ 'is a shell function' ]]; then
  unset -f open
fi
