#!/usr/bin/env bash

_gen_action() {
  local -r workflow_name="$1"
  local -r template_file_rel=".github/.workflow_templates/${workflow_name}.dhall"
  local -r output_file_rel=".github/workflows/${workflow_name}.yml"

  >&2 echo "Generating action from ${template_file_rel}"

  ( set -euo pipefail

    cat <<WRN
# Warning: this is an automatically generated file.
#
# It was generated using '${template_file_rel}'.
#
# Please avoid editing it manually unless doing so temporarily.

WRN
    dhall-to-yaml --omit-empty <<< "./${template_file_rel}"
  ) > "${output_file_rel}"
}

_gen_actions() {
  find '.github/.workflow_templates' -type f -name '*.dhall' | while read -r file_name; do
    _gen_action "$(basename "${file_name}" '.dhall')"
  done
}
