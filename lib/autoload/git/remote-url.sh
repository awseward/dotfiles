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
  case "$OSTTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/.*\:\/\/(.+\.[^/]+)\/.*/\1/'
    ;;
    (linux*)
      echo "$1" | sed -e 's/^.\+\:\/\/\(.\+\..\+\)\/.\+\/.\+$/\1/'
    ;;
  esac
}

__git_parse_remote_host_ssh() {
  case "$OSTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\1/g'
    ;;
    (linux*)
      echo "$1" | sed -e 's/.\+@\(.\+\..\+\)\:.*$/\1/'
    ;;
  esac
}

__git_parse_remote_owner_http() {
  case "$OSTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/.*\:\/\/.*\/(.+)\/.*/\1/'
    ;;
    (linux*)
      echo "$1" | sed -e 's/^.\+\:\/\/.\+\/\(.\+\)\/.\+$/\1/'
    ;;
  esac
}

__git_parse_remote_owner_ssh() {
  case "$OSTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\2/g'
    ;;
    (linux*)
      echo "$1" | sed -e 's/.\+\:\(.\+\)\/.*/\1/'
    ;;
  esac
}

__git_parse_remote_name_http() {
  case "$OSTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/.*\/(.+)$/\1/ ; s/\.git$//'
    ;;
    (linux*)
      echo "$1" | sed -e 's/^.\+\:\/\/.\+\/.\+\/\(.\+\)/\1/ ; s/\.git$//'
    ;;
  esac
}

__git_parse_remote_name_ssh() {
  case "$OSTYPE" in
    (darwin*)
      echo "$1" | sed -E 's/[[:alnum:]]+\@([[:alnum:]]+\.[[:alnum:]]+)\:([[:alnum:]]+)\/([[:alnum:]]+)(.git)?/\3/g'
    ;;
    (linux*)
      echo "$1" | sed -e 's/.*\/\(.\+\)$/\1/ ; s/.git$//'
    ;;
  esac
}
