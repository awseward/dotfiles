#!/usr/bin/env bash

launchctl_watch() {
  local plist="${1}"

  echo "Watching ${plist} to reload..."
  echo "${plist}" | entr -p sh -c "echo Reloading ${plist}; launchctl unload -w ${plist} && launchctl load -w ${plist}"
}
