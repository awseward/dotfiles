#!/usr/bin/env bash

set -euo pipefail

dotfiles="$HOME/.dotfiles"
tag="macos"

export RCRC="$dotfiles/rcrc" && rcdn -v -d "$dotfiles" -t "$tag"
