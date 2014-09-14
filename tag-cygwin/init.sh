# override open_url from ~/.lib/
open_url() {
  cygstart $1 > /dev/null 2>&1
}

__windows_init() {
  local win_home=$(cygpath $USERPROFILE)
  local procore=$win_home/Procore

  local analytics=$procore/Analytics
  local api=$procore/Api
  local document_processing=$procore/DocumentProcessing
  local p4d=$procore/ProcoreForDesktop
  local utilities=$procore/Utilities

  alias cdw="cd ${win_home}"
  alias procore="cd ${procore}"
  alias analytics="cd ${analytics}"
  alias api="cd ${api}"
  alias p4d="cd ${p4d}"
  alias utilities="cd ${utilities}"
  alias docproc="cd ${document_processing}"

  alias remux='rm -rf /tmp/tmux*'

  cd $p4d
}

__vagrant_init() {
  __ensure_in_PATH /cygdrive/c/Hashicorp/Vagrant/bin
  alias vag='cd ~/vagrant-ude && vagrant ssh'
}

__windows_init
__vagrant_init
