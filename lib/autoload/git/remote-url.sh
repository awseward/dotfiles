#!/bin/zsh

# git@host:owner/repo-name.git
url_is_ssh() {
  [[ "$1" =~ .+\@.+\:.+\/.+(.git)?$ ]]
}

# https://host/owner/repo-name.git
url_is_http() {
  [[ "$1" =~ .+\/.+\/.+(.git)?$ ]]
}

__git_error_invalid_remote_url() {
  echo "Error: invalid remote url: '$1'"
}

__git_parse_remote_host() {
  local url=$1

  if url_is_ssh "$url"; then
    __git_parse_remote_host_ssh "$url"
  elif url_is_http "$url"; then
    __git_parse_remote_host_http "$url"
  else
    __git_error_invalid_remote_url "$url"
    return 1
  fi
}

__git_parse_remote_owner() {
  local url=$1

  if url_is_ssh "$url"; then
    __git_parse_remote_owner_ssh "$url"
  elif url_is_http "$url"; then
    __git_parse_remote_owner_http "$url"
  else
    __git_error_invalid_remote_url "$url"
    return 1
  fi
}

__git_parse_remote_name() {
  local url=$1

  if url_is_ssh "$url"; then
    __git_parse_remote_name_ssh "$url"
  elif url_is_http "$url"; then
    __git_parse_remote_name_http "$url"
  else
    __git_error_invalid_remote_url "$url"
    return 1
  fi
}

__git_parse_remote_host_http() {
  echo "$1" | sed -e 's/^.\+\:\/\/\(.\+\..\+\)\/.\+\/.\+$/\1/'
}

__git_parse_remote_host_ssh() {
  echo "$1" | sed -e 's/.\+@\(.\+\..\+\)\:.*$/\1/'
}

__git_parse_remote_owner_http() {
  echo "$1" | sed -e 's/^.\+\:\/\/.\+\/\(.\+\)\/.\+$/\1/'
}

__git_parse_remote_owner_ssh() {
  echo "$1" | sed -e 's/.\+\:\(.\+\)\/.*/\1/'
}

__git_parse_remote_name_http() {
  echo "$1" | sed -e 's/^.\+\:\/\/.\+\/.\+\/\(.\+\)/\1/ ; s/\.git$//'
}

__git_parse_remote_name_ssh() {
  echo "$1" | sed -e 's/.*\/\(.\+\)$/\1/ ; s/.git$//'
}
