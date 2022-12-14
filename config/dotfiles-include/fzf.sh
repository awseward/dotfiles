#!/usr/bin/env bash

# (jr: [J]ump to [R]epo)
#
# NOTE: This assumes a convention of repositories being located in:
#       `$HOME/projects/…`
_keybind_g_repo() {
  git-fzf select_project_repo
  zle reset-prompt
}; zle -N _keybind_g_repo && bindkey '^J^R' _keybind_g_repo

# gb: [G]it [B]ranch
#
# NOTE: One big caveat of this is that with tmux in place, you have to do the
#       `^B` part twice, since that's the tmux prefix key.
_keybind_g_branch() {
  git-fzf select_branch
  zle reset-prompt
}; zle -N _keybind_g_branch && bindkey '^G^B' _keybind_g_branch
