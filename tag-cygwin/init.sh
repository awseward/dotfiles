# override open_url from ~/.helpers/
open_url() {
  cygstart $1 > /dev/null 2>&1
}

__windows_init() {
  local win_home=$(cygpath $USERPROFILE)
  local procore=$win_home/Procore

  local analytics=$procore/Analytics
  local api=$procore/Api
  local p4d=$procore/ProcoreForDesktop
  local utilities=$procore/Utilities

  alias cdw="cd ${win_home}"
  alias procore="cd ${procore}"
  alias analytics="cd ${analytics}"
  alias api="cd ${api}"
  alias p4d="cd ${p4d}"
  alias utilities="cd ${utilities}"

  cd $p4d
}

__windows_init
