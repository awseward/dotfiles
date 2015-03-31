# override open from ~/.lib/misc.sh
open() {
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

  alias cdw="cd ${win_home}"
}

__windows_procore_init() {
  local win_home=$(cygpath $USERPROFILE)
  local procore=$win_home/Procore
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

  [ -f "$pd" ] && cd $pd
}

__chocolatey_init() {
  # Different install locations
  __ensure_in_PATH /cygdrive/c/Chocolatey/chocolateyinstall
  __ensure_in_PATH /cygdrive/c/ProgramData/chocolatey/chocolateyinstall
}

__vagrant_init() {
  __ensure_in_PATH /cygdrive/c/Hashicorp/Vagrant/bin
  alias vag='cd ~/vagrant-ude && vagrant ssh'
}

__node_init() {
  __ensure_in_PATH '/cygdrive/c/Program Files/nodejs'
  __ensure_in_PATH /cygdrive/c/Users/Andrew/AppData/Roaming/npm
}

__procore_drive_init() {
  __ensure_in_PATH /cygdrive/c/Windows
  __ensure_in_PATH '/cygdrive/c/Program Files (x86)/Caphyon/Advanced Installer 11.6.3/bin/x86'
}

__MSBuild_init() {
  __ensure_in_PATH '/cygdrive/c/Program Files (x86)/MSBuild/12.0/Bin'
}

__go_init() {
  __ensure_in_PATH /cygdrive/c/Go/bin
}

__java_init() {
  __ensure_in_PATH '/cygdrive/c/Program Files/Java/jdk1.8.0_40/bin'
}

__scala_init() {
  __ensure_in_PATH '/cygdrive/c/Program Files (x86)/scala/bin'
  __ensure_in_PATH '/cygdrive/c/Program Files (x86)/sbt/bin'
}

alias tmx='tmux_socket_workaround'

__windows_init
__windows_procore_init
__chocolatey_init
__procore_drive_init
__vagrant_init
__node_init
__MSBuild_init
__go_init
__java_init
__scala_init


mux start cyg
