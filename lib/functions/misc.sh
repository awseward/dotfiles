scratch() {
  local -r extension="$1"
  local -r filepath="$(mktemp -d -t 'mkscratch-XXXX')/scratch.${extension}"

  "${EDITOR}" "${filepath}"
}
