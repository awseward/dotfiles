#!/usr/bin/env sh

case "$OSTYPE" in
  (linux*)
    open() {
      xdg-open "$1" &> /dev/null
    }
    ;;
esac

list_functions() {
  case "$OSTYPE" in
    (darwin*)
      typeset -f \
        | \grep -E '\(\)\ \{$' \
        | \sed -e 's/().*{$//'
      ;;
    (linux*)
      typeset -f \
        | grep '() {$' \
        | grep --invert-match '^_' \
        |  sed -e 's/().*$//'
      ;;
  esac
}

if type "fzf" > /dev/null; then
  # (jr for 'Jump to Repo')
  #
  # NOTE: This assumes a convention of repositories being located in:
  #       `$HOME/projects/$LANG_OR_CONTEXT/`
  function _jump-repo {
    local repo="$(find -H "$HOME/projects" -mindepth 2 -maxdepth 2 -type d -or -type l | fzf --height 25% --reverse --border --header='Repositories:')"
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
    local branch="$(git branch -r | tail -n +2 | sed -e 's/^\ *origin\///' | fzf --height 25% --reverse --border --header='Branches:')"

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
