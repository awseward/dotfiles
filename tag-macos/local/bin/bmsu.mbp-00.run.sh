#!/usr/bin/env bash

set -euo pipefail

eval "$(ssh-agent)" && ssh-add --apple-load-keychain

yes $'\n' | exec backup mbp-00
