# override open from ~/.lib/misc.sh
open() {
  cygstart "$1" > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
  echo $(ruby -e "$rb_cmd")
}

tmux_socket_workaround() {
  tmux -L $(print_new_uuid)
}

__set_git_autocrlf() {
  git config --system core.autocrlf true
}

__windows_init() {
  __set_git_autocrlf
  compinit # Not sure why we have to invoke this manually like this now...

  alias cdw="cd $(cygpath $USERPROFILE)"
}

__windows_procore_init() {
  local procore="$(cygpath $USERPROFILE)/Procore"
  local addin=$procore/ProjectAddIn
  local analytics=$procore/Analytics
  local api=$procore/Api
  local document_processing=$procore/DocumentProcessing
  local pd=$procore/Drive
  local utilities=$procore/Utilities

  alias procore="cd ${procore}"
  alias addin="cd ${addin}"
  alias analytics="cd ${analytics}"
  alias api="cd ${api}"
  alias pd="cd ${pd}"
  alias utilities="cd ${utilities}"
  alias docproc="cd ${document_processing}"

  [ -d "$pd" ] && cd "$pd"
}

__vagrant_init() {
  alias vag='cd ~/vagrant-ude && vagrant ssh'
}

__windows_init
__windows_procore_init
__vagrant_init

alias tmx='tmux_socket_workaround'

mux start cyg