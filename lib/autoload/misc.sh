#!/usr/bin/env bash

case "$OSTYPE" in
  (linux*)
    function open {
      xdg-open "$1" &> /dev/null
    }
  ;;
esac

if type "fzf" > /dev/null; then
  # (jr for 'Jump to Repo')
  #
  # NOTE: This assumes a convention of repositories being located in:
  #       `$HOME/projects/$LANG_OR_CONTEXT/`
  function _jump-repo {
    local repo
    repo="$(find -H "$HOME/projects" -mindepth 2 -maxdepth 2 -type d -or -type l | fzf --height 25% --reverse --border --header='Repositories:')"
    if [ "$repo" != '' ]; then
      cd "$repo" && pwd && l
    fi
    zle reset-prompt
  }
  zle -N _jump-repo && bindkey '^j^r' _jump-repo


  # (gh not for any real reason other than making it work)
  #
  # I wanted to use jb or gb for 'Jump to Branch' or `Git Branch', but neither
  # of those wanted to work. TODO: Figure out exactly why that is.
  function _git-branch {
    local branches
    branches=$(git branch -a | sed -E 's/remotes\/[^\/]*\///g; /(\*|HEAD).*$/d' | sort -u | awk '{$1=$1};1')
    local branch
    branch="$(echo "$branches" | fzf --height 25% --reverse --border --header='Branches:')"

    if [ "$branch" != '' ]; then
      git checkout "$branch"
    fi

    zle reset-prompt
  }
  zle -N _git-branch && bindkey '^g^h' _git-branch

  # TODO: Maybe reallocate '^g^h' for hub...
  #
  # Initial rough cut is this:
  #
  #   hub --help | ag -A 100 'GitHub commands' | tail -n +2 | sed -E 's/^\ +([^ ]+)\ .*$/\1/ ; /^$/d' | fzf | xargs hub
  #

  # (pv for 'PreView')
  # FIXME: This is too broken to be very useful for now.
  # function _preview-wd {
  #   ls | fzf --border --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap --bind 'enter:accept+execute(vim {})'
  #   zle reset-prompt
  # }
  # zle -N _preview-wd && bindkey '^p^v' _preview-wd
fi
