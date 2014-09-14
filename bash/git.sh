#!/bin/bash

isGit () {
  git rev-parse 2> /dev/null && return 0
  return 1
}

isMaster () {
  [ "$(git_branch)" = "master" ] && return 0
  return 1
}

isDiff () {
  [ "$(git diff --name-only 2>/dev/null)" ] && return 0
  return 1
}

git_branch () {
  isGit && git rev-parse --abbrev-ref HEAD
}

git_branch_no_check() {
  git rev-parse --abbrev-ref HEAD | tr -d '\n'
}

git_branch_brackets() {
  isGit && git_branch_brackets_no_check
}

git_branch_brackets_no_check () {
  echo -n '['
  git_branch_no_check
  echo -n ']'
}

git_branch_charsafe () {
  git_branch | sed -e 's/\/\|\:/-/g'
}

git_branch_colorcode () {
  if isGit; then
    local color_code=""
    local _isDiff=isDiff
    local _isMaster=isMaster
    $_isMaster && color_code=$bold$bg_red$color_code
    $_isDiff && color_code=$bold$yellow$color_code
    echo -e "$color_code"
  fi
}

git_timestamp () {
  if [ "$1" != "" ]; then
    echo -n $(date +%F__%R) && echo -n ".${1}" && echo "."$(git_branch)
  else
    echo -n $(date +%F__%R) && echo "."$(git_branch)
  fi
}

git_timestamp_charsafe () {
  if [ "$1" != "" ]; then
    git_timestamp "$1" | sed -e 's/\/\|\:/-/g'        
  else
    git_timestamp | sed -e 's/\/\|\:/-/g'
  fi
}

origin_url_base () {
  if isGit; then
    echo $(git remote -v | \
      grep -m1 origin | \
      sed -e 's_^.*@\(.*\)\:\(.*\)\/\(.*\) .*$_http\:\/\/\1\/\2\/\3_; s_\.git__')
  fi
}

github_compare () {
  echo -e "$bold$blue$(uncolored_github_compare)$clear"
}

uncolored_github_compare () {
  if [ isMaster = 1 ]; then
    origin_url_base
  else
    echo -e "$(origin_url_base)/compare/master...$(git_branch)"
  fi
}

bitbucket_compare () {
  echo -e "$bold$blue$(uncolored_bitbucket_compare)$clear"
}

uncolored_bitbucket_compare () {
  if [ isMaster = 1 ]; then
    origin_url_base
  else
    echo -e "$(origin_url_base)/compare/$(git_branch)..master#diff"
  fi
}

git_compare () {
  if isGit; then
    if [[ "$(git remote -v | grep -m1 'origin')" = *github* ]]; then
      github_compare
    else
      bitbucket_compare
    fi
  fi
}

uncolored_git_compare () {
  if isGit; then
    if [[ "$(git remote -v | grep -m1 'origin')" = *github* ]]; then
      uncolored_github_compare
    else
      uncolored_bitbucket_compare
    fi
  fi
}

git_push () {
  if isGit; then
    ahead=$(git_commits_ahead)
    if [ $ahead -ne 0 ]; then
      git push origin HEAD
      echo -e "\n${underline}Commits in this push$clear"
      git_last_n_commits $ahead
    else
      echo -e "${red}No commits to push...$clear"
      echo -e "\n${underline}Latest Commit${clear}\n$(git_last_n_commits 1)\n"
    fi
    isMaster || echo -e "\n${underline}Diff${clear}\n$(git_compare)\n"
  fi
}

git_pull_changes () {
  if isGit; then
    if [ $1 ] && [ "$1" != $(git_branch) ]; then
      echo -e "$cyan$(git checkout $1 2>&1)$clear"
    fi
    git fetch origin
    if [ $(git_commits_behind) -ne 0 ]; then
      git pull
    fi
  fi
}

git_pull_master () {
  if isGit; then
    git pull origin master
  fi
}

git_create_branch () { # stolen from grb...
  git push origin $(git_branch):refs/heads/$1
  git fetch origin
  git branch --track $1 origin/$1
  echo -e "$cyan$(git checkout $1 2>&1)$clear"
}

git_delete_branch () { # also stolen from grb...
  branch_to_delete=$(git_branch)
  if isGit; then
    if [ "$branch_to_delete" != "master" ]; then
      git push origin ":$branch_to_delete"
      echo -e "$cyan$(git checkout master 2>&1)$clear"
      git branch -D $branch_to_delete
    fi
  fi
}

git_commit_all () { # takes arguments...
  message="$@"
  if isGit; then
    git commit -am "commit_all: $message"
  fi
}

git_last_n_commits () {
  commit=commit
  if [[ "$(git remote -v | grep -m1 'origin')" = *bitbucket* ]]; then
    commit="$commit"s
  fi

  local IFS=$'\n'
  array=( $(git log --pretty=format:"%h $clear$yellow(%ar)$clear" -n $1) )
  for thing in "${array[@]}"; do
    echo -e "$bold$blue$(origin_url_base)/$commit/$thing"
  done
}

git_last_n_commit_hashes () {
  git log --pretty=format:"%h" -n $1
}

git_commits_ahead () {
  if [ "$1" != "" ]; then
    branch=$1
  else
    branch=$(git_branch)
  fi
  git rev-list --count HEAD ^origin/$branch
}

git_commits_behind () {
  if [ "$1" != "" ]; then
    branch=$1
  else
    branch=$(git_branch)
  fi
  git rev-list --count origin/$branch ^HEAD
}

git_merge_master_into_all () {
  local starting_branch=$(git_branch)
  if [ "$1" ]; then
    local branches=( $(git branch | grep "$1" | sed 's/\(\ *\|*\|master\)//g') )
  else
    local branches=( $(git branch | sed 's/\(\ *\|*\|master\)//g') )
  fi

  # lol...
  for second in {3..1}; do
    clear
    echo -e $yellow"MERGING MASTER INTO THE FOLLOWING BRANCHES:\n"$clear
    for branch in "${branches[@]}"; do
      echo -e $yellow"  "$branch$clear
    done
    echo
    echo -n "Merging in "$second
    sleep 0.33
    echo -n "."
    sleep 0.33
    echo -n "."
    sleep 0.33
  done
  clear

  git_pull_changes master
  for branch in "${branches[@]}"; do
    echo -e "$cyan$(git checkout $branch 2>&1)$clear"
    local needs_master=$(git branch --no-merge | grep "master")

    if [ "$needs_master" ]; then
      git merge master
    fi

    if [ $(git_commits_ahead) -ne 0 ]; then
      git_push
    fi
  done
  if [ $(git_branch) != $starting_branch ]; then
    echo -e "$cyan$(git checkout $starting_branch 2>&1)$clear"
  fi
}

git_ude_merge_master_into_all () {
  if [ "$(hostname)" = "developer.andrew" ]; then
    git_merge_master_into_all "dev/as"
  fi
}

git_ticket_number () {
  if [ "$1" != "" ]; then
    branch="$1"
  else
    branch=$(git_branch)
  fi
  array=($(echo "$branch" | sed 's/[^0-9]/ /g'))
  arrayLength=${#array[@]}
  lastIndex=$(($arrayLength-1))
  echo ${array[$lastIndex]}
}

git_sandbox () {
  git branch | sed -e 's/\*\|\ *//g' | while read current_branch; do
  git checkout $current_branch
  git checkout -b sandbox/$current_branch
  git push -u origin HEAD
  git branch
done
  }