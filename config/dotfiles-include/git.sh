#!/usr/bin/env bash

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_get_pruneables() {
  local r_name="${1:-origin}"
  git fetch "$r_name";
  git remote prune -n "$r_name" | command grep --only-matching "$r_name/.\+" | sed -E "s/^$r_name\/(.+)$/\1/g"
}

git_delete_pruneables() {
  local r_name="${1:-origin}"
  local branches
  branches="$(git_get_pruneables "$r_name")"

  [ -z "$branches" ] && return 0

  local curr_br
  curr_br="$(git_current_branch)"

  for br in "${branches[@]}"; do
    if [ "$curr_br" = "$br" ]; then
      >&2 echo "ERROR: Current branch ($curr_br) is included in list of branches to prune & delete: (${branches[*]})"
      return 1
    fi
  done

  echo "$branches" | xargs git branch --delete || true && git remote prune "$r_name"
}
