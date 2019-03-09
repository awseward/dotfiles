#!/usr/bin/env sh

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

git_delete_pruneable_branches() {
  local branches
  branches="$(__git_pruneable_branches)"

  if [ -n "$branches" ]; then
    echo "Deleting local branches eligible for pruning"
    echo "$branches" | xargs git branch -D 2> /dev/null
    git remote prune origin
  else
    echo "No branches to prune"
  fi
}

__git_pruneable_branches() {
  git fetch origin;
  git remote prune -n origin | grep 'origin/.*' -o  | sed -e "s/^.*origin\/\(.*\)/\1/g"
}
