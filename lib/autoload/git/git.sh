#!/usr/bin/env bash

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_delete_branch_local() {
  local current_branch
  current_branch="$(git_current_branch)"

  if __git_branch_is_master "$current_branch"; then
    __git_error_cannot_delete_master
    return 1
  else
    git reset --hard
    git checkout master
    git branch -D "$current_branch"
  fi
}

git_delete_current_branch_local() {
  git_delete_branch_local "$(git_current_branch)"
}

git_delete_branch_remote() {
  local branch
  branch="$1"

  if __git_branch_is_master "$branch"; then
    __git_error_cannot_delete_master
    return 1
  else
    git push origin ":$branch"
  fi
}

git_delete_current_branch_remote() {
  git_delete_branch_remote "$(git_current_branch)"
}

git_cherry_pick_and_reset() {
  local sha
  sha="$1"

  git cherry-pick "$sha" && git reset --mixed HEAD~1
}

__git_branch_is_master() {
  [ "$1" = "master" ]
}

__git_error_cannot_delete_master() {
  echo "Error: cannot delete 'master'"
}

git_nuke_branch() {
  local branch
  branch="$1"

  git_delete_branch_remote "$branch" && git_delete_branch_local "$branch"
}

git_nuke_current_branch() {
  git_nuke_branch "$(git_current_branch)"
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
