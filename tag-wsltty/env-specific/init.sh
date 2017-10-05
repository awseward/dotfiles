export LS_COLORS="ow=0"
export SHELL="/bin/zsh" # isn't getting updated/set propertly by chsh, so just setting it manually here

alias fake="./fake.sh "
alias hub="hub.exe " # should be temporary... find a better way
alias open="explorer.exe" # override open from ~/.lib/misc.sh
alias paket="./paket.sh "

umask 022 # WSL Windows /mnt/* dir permissions workaround
git config --system core.autocrlf true


psh() {
  local psh_path

  if [ "$1" = "" ]; then
    psh_path="$(pwd)"
  else
    psh_path="$1"
  fi


  cmd.exe /c start powershell -noexit -command "cd $(wslpath -w $psh_path)"
}
