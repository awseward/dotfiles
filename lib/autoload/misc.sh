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

  # (pv for 'PreView')
  function _preview-wd {
    ls | fzf --border --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap --bind 'enter:accept+execute(vim {})'
    zle reset-prompt
  }
  zle -N _preview-wd && bindkey '^p^v' _preview-wd
fi
