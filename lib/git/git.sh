#!/bin/sh

git_is_repo() {
  git rev-parse 2> /dev/null
}

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_remote_host() {
  __git_parse_remote_host "$(__git_origin_clone_url)"
}

git_remote_owner() {
  __git_parse_remote_owner "$(__git_origin_clone_url)"
}

git_remote_name() {
  __git_parse_remote_name "$(__git_origin_clone_url)"
}

git_remote_url() {
  local remote_url
  local r_host
  local r_owner
  local r_name
  remote_url=$(__git_origin_clone_url)
  r_host=$(__git_parse_remote_host "$remote_url")
  r_owner=$(__git_parse_remote_owner "$remote_url")
  r_name=$(__git_parse_remote_name "$remote_url")

  echo "https://$r_host/$r_owner/$r_name"
}

git_open_remote() {
  open "$(git_remote_url)"
}

git_remote_compare_url() {
  local current_branch
  local remote_url
  current_branch=$(git_current_branch)
  remote_url=$(git_remote_url)

  if __git_branch_is_master "$current_branch"; then
    # No comparison to be done on master...
    echo "$remote_url"
  else
    echo "$remote_url/compare/master...$current_branch"
  fi
}

git_remote_compare() {
  open "$(git_remote_compare_url)"
}

git_push_and_compare() {
  git push -u origin HEAD && git_remote_compare_url
}

git_delete_branch_local() {
  local current_branch
  current_branch=$(git_current_branch)

  if __git_branch_is_master "$current_branch"; then
    __git_error_cannot_delete_master
    return 1
  else
    git reset --hard
    git checkout master
    git branch -D "$current_branch"
  fi
}

git_delete_branch_remote() {
  local current_branch
  current_branch=$(git_current_branch)

  if __git_branch_is_master "$current_branch"; then
    __git_error_cannot_delete_master
    return 1
  else
    git push origin ":$(git_current_branch)"
  fi
}

__git_branch_is_master() {
  [ "$1" = "master" ]
}

__git_error_cannot_delete_master() {
  echo "Error: cannot delete 'master'"
}

git_nuke_branch() {
  git_delete_branch_remote && git_delete_branch_local
}

git_delete_pruneable_branches() {
  local branches
  branches="$(__git_pruneable_branches)"

  if [ -n "$branches" ]; then
    echo "$branches" | xargs git branch -D
    git remote prune origin
  else
    echo No branches to prune
  fi
}

__git_origin_clone_url() {
  git config remote.origin.url
}

__git_pruneable_branches() {
  git fetch origin;
  git remote prune -n origin | grep 'origin/.*' -o  | sed -e "s/^.*origin\/\(.*\)/\1/g"
}
