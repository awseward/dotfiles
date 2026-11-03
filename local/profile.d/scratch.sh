#!/usr/bin/env bash

__ensure_scratch_setup() {
  export __SCRATCH_DIR="${__SCRATCH_DIR:=${XDG_CACHE_HOME:-${HOME}/.cache}/scratch}"
  echo "${__SCRATCH_DIR}"
}

# Make a scratch temp file with the given extension and print its absolute path.
# Relies on GNU mktemp's support for a suffix after the X's; BSD mktemp only
# substitutes *trailing* X's, so coreutils mktemp must win on PATH.
__scratch_mktemp() {
  local -r extension="${1}"
  local -r base_path="${__SCRATCH_DIR}"
  mkdir -p "${base_path}"

  mktemp "${base_path}/XXXXXXXX.scratch.${extension}"
}

scratch() {
  __ensure_scratch_setup

  local -r extension="${1:-}"
  local -r base_path="${__SCRATCH_DIR}"
  mkdir -p "${base_path}"

  if [ "${extension}" = '' ]; then
    cd "${base_path}" || return
  else
    local filepath
    filepath="$(__scratch_mktemp "${extension}")" || return

    "${EDITOR}" "${filepath}"
  fi
}

# Like `scratch [ext]`, but after you save and exit EDITOR, put the file's
# absolute path on the clipboard. For handing a large blob to an agent by path
# instead of pasting it into the terminal and bloating the scrollback/context.
pbscratch() {
  __ensure_scratch_setup >/dev/null

  local -r extension="${1:-txt}"
  local filepath
  filepath="$(__scratch_mktemp "${extension}")" || return

  "${EDITOR}" "${filepath}"

  printf '%s' "${filepath}" | pbcopy
  echo "${filepath}  (path copied to clipboard)"
}
