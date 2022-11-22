#!/usr/bin/env bash

set -euo pipefail

# See:
# - https://p.mort.coffee/
# - https://sr.ht/~mort/coffeepaste/

w_stdin() {
  >&2 echo "curl -fsS --upload-file - $WEBCB_HOST"
  curl -fsS --upload-file - "$WEBCB_HOST"
}

w_file() { xargs -t      curl -fsS "$WEBCB_HOST" --upload-file <<< "$1"; }

r_id()   { xargs -t -I{} curl -fsS "$WEBCB_HOST/{}" <<< "$1"; }

r_url()  { xargs -t      curl -fsS <<< "$1"; }

help_backend() { open "$WEBCB_HOST"; }

help() {
  local -r f_="$(basename "$0")"
  local -r gh_link='https://github.com/awseward/dotfiles/bin/webcb.sh'

  cat <<-TXT

A web clipboard CLI client.

Currently using https://p.mort.coffee as its backend, but intended as a facade
so that scripts and workflows building on this can ignore this fact as an
implementation detail.

Callers MUST NOT expect anything uploaded via this to be encrypted or otherwise
secured in any manner.

Usages:

  = Write from STDIN =
  $f_ w_stdin <<< 'Your text here'

  = From a file =
  $f_ w_file /your/file/here

  = Read by ID =
  $f_ r_id abc123
  -or-
  $f_ r_id abc123.txt

  = Read by URL =
  $f_ r_url $WEBCB_HOST/abc123
  -or-
  $f_ r_url $WEBCB_HOST/abc123.txt

  = Override the host =
  WEBCB_HOST='https://your.own.instance.com' $f_ w_stdin <<< 'Your text here'

---
See also: $gh_link

TXT
}

# ---

WEBCB_HOST="${WEBCB_HOST:-https://p.mort.coffee}"

"${@:-help}"
