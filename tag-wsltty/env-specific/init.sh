psh() {
  local psh_path

  case "$1" in
    "" ) psh_path="$(pwd)" ;;
    ".") psh_path="$(pwd)" ;;
    *  ) psh_path="$1" ;;
  esac

  cmd.exe /c start powershell -noexit -command "cd $(wslpath -w $psh_path)"
}

win_env() {
  if [ "$1" = "" ]; then
    return 1
  fi

  local paren_wrapped
  paren_wrapped="%$1%"

  local cmd_exe_arg
  cmd_exe_arg="echo $paren_wrapped"

  local cmd_result
  cmd_result="$(cmd.exe /C $cmd_exe_arg 2>&1 | tail -n1 | sed 's/\r$//g')"

  if [ "$cmd_result" = "$paren_wrapped" ]; then
    echo
  else
    echo -E "$cmd_result"
  fi
}

export LS_COLORS="ow=0"
export SHELL="/bin/zsh" # isn't getting updated/set propertly by chsh, so just setting it manually here

export USERPROFILE="$(wslpath -u $(win_env 'USERPROFILE'))"
export LOCALAPPDATA="$(wslpath -u $(win_env 'LOCALAPPDATA'))"

alias fake="./fake.sh "
alias hub="hub.exe " # should be temporary... find a better way
alias lappd='cd "$LOCALAPPDATA"'
alias open="explorer.exe" # override open from ~/.lib/misc.sh
alias paket="./paket.sh "
alias uspro='cd "$USERPROFILE"'

umask 022 # WSL Windows /mnt/* dir permissions workaround
git config --system core.autocrlf true
