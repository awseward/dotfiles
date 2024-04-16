#!/usr/bin/env bash

# jr: [J]ump to [R]epo
#
# NOTE: This assumes a convention of repositories being located in:
#       `$HOME/projects/…`
__bindkey_jr() {
  local repo; repo="$(git-fzf select_project_repo)"; readonly repo

  if [ "$repo" != '' ]; then
    cd "$repo" || return 1
    echo
    echo -ne "→ "; pwd; echo '---'
    zle reset-prompt
  fi
}
zle -N __bindkey_jr
bindkey '^J^R' __bindkey_jr

# gb: [G]it [B]ranch
#
# NOTE: One big caveat of this is that with tmux in place, you have to do the
#       `^B` part twice, since that's the tmux prefix key.
__bindkey_gb() {
  local branch; branch="$(git-fzf select_branch)"; readonly branch

  if [ "$branch" != '' ]; then
    git checkout "$branch"
    zle reset-prompt
  fi
}
zle -N __bindkey_gb
bindkey '^G^B' __bindkey_gb

# ew: [E]dit [W]hich
#
# shellcheck disable=SC2016
bindkey -s '\ee\ew' '"$EDITOR" "$(which ^I)"^J'

# rl: [R]eload [L]aunchAgent
__bindkey_rl() {
  local target; target="$(
    find "$HOME/Library/LaunchAgents" -type f -name '*.plist' \
      | fzf \
        --border                     \
        --header 'LaunchAgents'      \
        --height '25%'               \
        --prompt 'launchctl reload ' \
        --reverse                    \
        --exit-0
  )";

  # shellcheck disable=SC2181
  if [ $? != 0 ]; then
    zle reset-prompt
    return
  fi

  readonly target
  # shellcheck disable=SC2034
  RBUFFER+="launchctl unload -w $target; launchctl load -w $target"
  zle accept-line
}
zle -N __bindkey_rl
bindkey '\er\el' __bindkey_rl
