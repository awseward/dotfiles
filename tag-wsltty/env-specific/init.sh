psh() {
  local psh_path

  case "$1" in
    "" ) psh_path="$(pwd)" ;;
    ".") psh_path="$(pwd)" ;;
    # TODO: This could use some more work. For example, if you're under
    # a lxss dir that will need translating, you can't just type `open lib`
    # at the moment. You'd need to type open "$(pwd)/lib"
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

# override open from ~/.lib/misc.sh
open() {
  local arg_path

  case "$1" in
    "" ) arg_path="$(pwd)" ;;
    ".") arg_path="$(pwd)" ;;
    *  ) arg_path="$1" ;;
  esac

  explorer.exe "$(wslpath -w $arg_path)"
  return 0
}

# this is just a placeholder for macOS Sierra clipboard workaround described
# here: https://github.com/tmux/tmux/issues/543#issuecomment-248980734"
reattach-to-user-namespace() { }

export LS_COLORS="ow=0"
export SHELL="/bin/zsh" # isn't getting updated/set propertly by chsh, so just setting it manually here

export USERPROFILE="$(wslpath -u $(win_env 'USERPROFILE'))"
export LOCALAPPDATA="$(wslpath -u $(win_env 'LOCALAPPDATA'))"

alias fake="./fake.sh "
alias paket="./paket.sh "
alias hub="hub.exe " # should be temporary... find a better way
alias lappd='cd "$LOCALAPPDATA"'
alias uspro='cd "$USERPROFILE"'

umask 022 # WSL Windows /mnt/* dir permissions workaround
git config --system core.autocrlf true
