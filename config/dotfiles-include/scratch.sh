#!/usr/bin/env bash

__ensure_scratch_setup() {
  export __SCRATCH_DIR="${__SCRATCH_DIR:=${XDG_CACHE_HOME:-${HOME}/.cache}/scratch}"
  echo "${__SCRATCH_DIR}"
}

scratch() {
  __ensure_scratch_setup

  local -r extension="${1:-}"
  local -r base_path="${__SCRATCH_DIR}"
  mkdir -p "${base_path}"

  if [ "${extension}" = '' ]; then
    cd "${base_path}" || return
  else
    filepath="$(mktemp "${base_path}/XXXXXXXX.scratch.${extension}")"

    "${EDITOR}" "${filepath}"
  fi
}
