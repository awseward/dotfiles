#!/usr/bin/env bash

function git_current_branch {
  git rev-parse --abbrev-ref HEAD
}

function git_get_pruneables {
  local r_name="${1:-origin}"
  git fetch "$r_name";
  git remote prune -n "$r_name" | command grep --only-matching "$r_name/.\+" | sed -E "s/^$r_name\/(.+)$/\1/g"
}

function git_delete_pruneables {
  local r_name="${1:-origin}"
  local branches="$(git_get_pruneables $r_name)"

  [ ! -n "$branches" ] && return 0

  local curr_br="$(git_current_branch)"

  for br in "${branches[@]}"; do
    if [ "$curr_br" = "$br" ]; then
      >&2 echo "ERROR: Current branch ($curr_br) is included in list of branches to prune & delete: (${branches[@]})"
      return 1
    fi
  done

  echo "$branches" | xargs git branch --delete && git remote prune "$r_name"
}
