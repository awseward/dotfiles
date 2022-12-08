#!/usr/bin/env bash

set -euo pipefail

dirname "${0}" | xargs -I{} echo '{}/entrypoint.dhall' | dhall text
