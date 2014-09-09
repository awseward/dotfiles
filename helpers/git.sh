#!/bin/sh

git_is_repo() {
  git rev-parse 2> /dev/null && return 0
  return 1
}

git_current_branch() {
  git rev-parse --abbrev-ref HEAD | tf -d '\n'
}

git_remote_url() {
  local remote_string="$(git remote -v | head -n1)"
  local r_host=$(git_parse_remote_host $remote_string)
  local r_owner=$(git_parse_remote_owner $remote_string)
  local r_name=$(git_parse_remote_name $remote_string)
  echo "https://${r_host}/${r_owner}/${r_name}"
}

git_parse_remote_host() {
  echo "$@" | sed -e 's/.\+@\(.\+\.com\).*/\1/'
}

git_parse_remote_owner() {
  echo "$@" | sed -e 's/.\+\:\(.\+\)\/.*/\1/'
}

git_parse_remote_name() {
  echo "$@" | sed -e 's/.\+\/\(.\+\)\.git.*/\1/'
}
