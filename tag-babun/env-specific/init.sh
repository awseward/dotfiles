# override open from ~/.lib/misc.sh
open() {
  explorer "$1" > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd
  rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
  ruby -e "$rb_cmd"
}

__set_git_autocrlf() {
  git config --system core.autocrlf true
}

# I don't really think this actually needs to be a function that is just called
# right away and then nowhere else...
__windows_init() {
  __set_git_autocrlf
  compinit # Not sure why this needs to be invoked manually like this now...

  alias cdw='cd "$USERPROFILE"'
  export PERL5LIB=/usr/lib/perl5/vendor_perl/5.14
}

__windows_init
