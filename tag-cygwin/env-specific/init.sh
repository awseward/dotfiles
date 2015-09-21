# override open from ~/.lib/misc.sh
open() {
  cygstart "$1" > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
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

__windows_procore_init() {
  export PROCORE_DIR="$(cygpath "$USERPROFILE")/Procore"
  export PD_DIR="$PROCORE_DIR/Drive"
  export PD_ADDIN_DIR="$PROCORE_DIR/ProjectAddIn"
  export CHAUFFEUR_DIR="$PROCORE_DIR/chauffeur"
  export BOBCAT_DIR="$PROCORE_DIR/bobcat"
  export DOCUMENT_PROCESSING_DIR="$PROCORE_DIR/DocumentProcessing"

  alias procore='cd $PROCORE_DIR'
  alias pd='cd $PD_DIR'
  alias addin='cd $PD_ADDIN_DIR'
  alias chauffeur='cd $CHAUFFEUR_DIR'
  alias bobcat='cd $BOBCAT_DIR'
  alias docproc='cd $DOCUMENT_PROCESSING_DIR'

  [ -d "$PD_DIR" ] && cd "$PD_DIR"
}

__vagrant_init() {
  alias vag='cd ~/vagrant-ude && vagrant ssh'
}

__windows_init
__windows_procore_init
__vagrant_init

alias tmx='tmux_socket_workaround'

mux start cyg
