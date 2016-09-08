# override open from ~/.lib/misc.sh

open() {
  explorer "$1" > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd
  rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
  ruby -e "$rb_cmd"
}

tmux_socket_workaround() {
  tmux -L "$(print_new_uuid)"
}

__set_git_autocrlf() {
  git config --system core.autocrlf true
}

__windows_init() {
  __set_git_autocrlf
  compinit # Not sure why we have to invoke this manually like this now...

  alias cdw='cd "$USERPROFILE"'
}

__windows_init

alias tmx='tmux_socket_workaround'
