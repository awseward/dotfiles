#!/usr/bin/env bash

# (jr: [J]ump to [R]epo)
#
# NOTE: This assumes a convention of repositories being located in:
#       `$HOME/projects/…`
__bindkey_jr() {
  git-fzf select_project_repo
  zle reset-prompt
}
zle -N __bindkey_jr

# gb: [G]it [B]ranch
#
# NOTE: One big caveat of this is that with tmux in place, you have to do the
#       `^B` part twice, since that's the tmux prefix key.
__bindkey_gb() {
  git-fzf select_branch
  zle reset-prompt
}
zle -N __bindkey_gb

bindkey '^J^R' __bindkey_jr
bindkey '^G^B' __bindkey_gb
# shellcheck disable=SC2016
# ew: [E]dit [W]hich
bindkey -s '\ee\ew' '"$EDITOR" "$(which ^I)"^J'
