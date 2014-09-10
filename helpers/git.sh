#!/bin/sh

git_is_repo() {
  git rev-parse 2> /dev/null && return 0
  return 1
}

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_remote_host() {
  __git_parse_remote_host $(__git_filter_remote_v origin)
}

git_remote_owner() {
  __git_parse_remote_owner $(__git_filter_remote_v origin)
}

git_remote_name() {
  __git_parse_remote_name $(__git_filter_remote_v origin)
}

git_remote_url() {
  local remote_string="$(__git_filter_remote_v origin)"
  local r_host=$(__git_parse_remote_host $remote_string)
  local r_owner=$(__git_parse_remote_owner $remote_string)
  local r_name=$(__git_parse_remote_name $remote_string)

  echo "https://${r_host}/${r_owner}/${r_name}"
}

git_delete_branch_local() {
  local current_branch=$(git_current_branch)
  [ "$current_branch" = master ] && return 1

  git reset --hard
  git checkout master
  git branch -D $current_branch
}

git_delete_branch_remote() {
  git push origin :$(git_current_branch)
}

git_nuke_branch() {
  git_delete_branch_remote
  git_delete_branch_local
}

__git_filter_remote_v() {
  git remote -v | grep -m1 "^${1}\s.*$"
}

__git_parse_remote_host() {
  echo "$@" | sed -e 's/.\+@\(.\+\.com\).*/\1/'
}

__git_parse_remote_owner() {
  echo "$@" | sed -e 's/.\+\:\(.\+\)\/.*/\1/'
}

__git_parse_remote_name() {
  echo "$@" | sed -e 's/.\+\/\(.\+\)\.git.*/\1/'
}
