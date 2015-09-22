__git_parse_remote_host() {
  echo "$@" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\1/g'
}

__git_parse_remote_owner() {
  echo "$@" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\2/g'
}

__git_parse_remote_name() {
  echo "$@" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\3/g'
}

__canonicalize_path() {
  realpath "$1" 2>/dev/null
}

alias ls="ls -hFG"
alias rm="rm -dv"

# Unset open() from ~/.lib/misc.sh
unset -f open
