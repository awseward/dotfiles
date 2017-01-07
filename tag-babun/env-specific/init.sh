# override open from ~/.lib/misc.sh
open() {
  explorer "$1" > /dev/null 2>&1
}

print_new_uuid() {
  local rb_cmd
  rb_cmd="require 'securerandom'; puts SecureRandom.uuid"
  ruby -e "$rb_cmd"
}

# Env vars
export PERL5LIB=/usr/lib/perl5/vendor_perl/5.14

# Aliases
alias cdw='cd "$USERPROFILE"'
alias psh='cmd /c start powershell'

# Misc
git config --system core.autocrlf true
compinit # Not sure why this needs to be invoked manually like this now...
