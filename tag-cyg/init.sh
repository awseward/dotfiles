# override open_url from ~/.lib/
open_url() {
  cygstart $1 > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
  echo $(ruby -e "$rb_cmd")
}

tmux_socket_workaround() {
  tmux -L $(print_new_uuid)
}

__windows_init() {
  compinit # Not sure why we have to invoke this manually like this now...

  local win_home=$(cygpath $USERPROFILE)
  local procore=$win_home/Procore

  local analytics=$procore/Analytics
  local api=$procore/Api
  local document_processing=$procore/DocumentProcessing
  local p4d=$procore/Drive
  local utilities=$procore/Utilities

  alias cdw="cd ${win_home}"
  alias procore="cd ${procore}"
  alias analytics="cd ${analytics}"
  alias api="cd ${api}"
  alias p4d="cd ${p4d}"
  alias utilities="cd ${utilities}"
  alias docproc="cd ${document_processing}"

  __ensure_in_PATH /cygdrive/c/Chocolatey/chocolateyinstall

  cd $p4d
}

__vagrant_init() {
  __ensure_in_PATH /cygdrive/c/Hashicorp/Vagrant/bin
  alias vag='cd ~/vagrant-ude && vagrant ssh'
}

alias tmx='tmux_socket_workaround'

__windows_init
__vagrant_init

mux start cyg
