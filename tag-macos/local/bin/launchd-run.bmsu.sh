#!/usr/bin/env bash

set -euo pipefail

>&2 echo ''
>&2 echo "; $0 $*"
>&2 echo ''

repo_name="$1"

( # TODO: Respect XDG_RUNTIME_DIR from
  # https://web.archive.org/web/20250624041402/https://specifications.freedesktop.org/basedir-spec/0.8/
  #
  # For now, we can make an attempt to meet at least this part of the spec:
  #
  # > The directory MUST be owned by the user, and he MUST be the only one
  # > having read and write access to it. Its Unix access mode MUST be 0700.
  #
  # Although, this DOESN'T comply with others, like:
  #
  # > The lifetime of the directory MUST be bound to the user being logged in. It
  # > MUST be created when the user first logs in and if the user fully logs out
  # > the directory MUST be removed. If the user logs in more than once he should
  # > get pointed to the same directory, and it is mandatory that the directory
  # > continues to exist from his first login to his last logout on the system,
  # > and not removed in between. Files in the directory MUST not survive reboot
  # > or a full logout/login cycle.
  #
  # Oh well, I just want to have a service that doesn't hang when logs get
  # rotated…
  #
  umask 0077
  mkdir -p   "$HOME/.local/tmp/bmsu"
  touch      "$HOME/.local/tmp/bmsu/$repo_name.pid"
); echo $$ > "$HOME/.local/tmp/bmsu/$repo_name.pid"

>&2 echo -n "$HOME/.local/tmp/bmsu/$repo_name.pid: "; >&2 cat "$HOME/.local/tmp/bmsu/$repo_name.pid"

eval "$(ssh-agent)" && ssh-add --apple-load-keychain

yes $'\n' | exec backup "$repo_name"
