#!/bin/bash
psgrep() {
  ps aux | fgrep -is "$1" | fgrep -v "fgrep --color=auto -is $1"
}

pull_dotfile_changes() {
  if [ -d "$dotfiles_dir" ]; then
    cd $dotfiles_dir
    git_pull_changes
  fi
}

push_dotfile_changes() {
  message="$@"
  if [ -d "$dotfiles_dir" ]; then
    cd $dotfiles_dir
    git_commit_all "$message"
    git_push
  fi
}

pi_status () {
  ssh andrew@pi '~/public_html/cap/script/check_site_status.sh'
}

pi_pull () {
  ssh andrew@pi '~/public_html/cap/script/pull_site_changes.sh'
}

git_prompt_function() {
  echo
  git st
  echo
}

git_prompt_function_wrapper() {
  if [ "$BASH_COMMAND" = "" ]; then
    isGit && git_prompt_function
  fi
}

open() {
  if [ "$1" != "" ]; then
    result=$1
  else
    result="."
  fi
  cygstart $result
}
