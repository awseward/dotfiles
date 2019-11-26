#!/usr/bin/env bash

g_repo() {
  local repo
  repo="$(find -H "$HOME/projects" -mindepth 2 -maxdepth 2 -type d -or -type l | fzf --height 25% --reverse --border --header='Repositories:')"
  if [ "$repo" != '' ]; then
    cd "$repo" && pwd && l
  fi
}

g_branch() {
  local branches
  branches=$(git branch -a | sed -E 's/remotes\/[^\/]*\///g; /(\*|HEAD).*$/d' | sort -u | awk '{$1=$1};1')
  local branch
  branch="$(echo "$branches" | fzf --height 25% --reverse --border --header='Branches:')"

  if [ "$branch" != '' ]; then
    git checkout "$branch"
  fi
}

# (jr for 'Jump to Repo')
#
# NOTE: This assumes a convention of repositories being located in:
#       `$HOME/projects/$LANG_OR_CONTEXT/`
_keybind_g_repo() {
  g_repo
  zle reset-prompt
}
zle -N _keybind_g_repo && bindkey '^j^r' _keybind_g_repo

# (gh not for any real reason other than making it work)
#
# I wanted to use jb or gb for 'Jump to Branch' or `Git Branch', but neither
# of those wanted to work. TODO: Figure out exactly why that is.
_keybind_g_branch() {
  g_branch
  zle reset-prompt
}
zle -N _keybind_g_branch && bindkey '^g^h' _keybind_g_branch
