#!/usr/bin/env bash

_gen_action() {
  local -r workflow_name="$1"

  ( set -euo pipefail

    cat <<WRN
# Warning: this is a generated file; please avoid editing it manually unless
# doing so temporarily.

WRN
    dhall-to-yaml <<< "./.github/.workflow_templates/${workflow_name}.dhall"
  ) > "./.github/workflows/${workflow_name}.yml"
}
