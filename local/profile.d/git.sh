#!/usr/bin/env bash

git_current_branch() { git rev-parse --abbrev-ref HEAD; }

# This is mostly just here for backwards compatibility
git_delete_pruneables() { git delete-pruneable-branches "$@"; }
