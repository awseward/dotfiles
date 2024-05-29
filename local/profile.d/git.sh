#!/usr/bin/env bash

git_current_branch() { git rev-parse --abbrev-ref HEAD; }

# This is mostly just here for backwards compatibility
git_delete_pruneables() { git delete-pruneable-branches "$@"; }

# (P)(B)copy (G)it (B)ranch name
pbgb_q() { git rev-parse --abbrev-ref HEAD | tee >(xargs echo -n | pbcopy); }
# (P)(B)copy (G)it commit (S)ha
pbgs_q() { git rev-parse HEAD | tee >(xargs echo -n | pbcopy); }

pbgb() { >&2 git msg; >&2 echo; pbgb_q; }
pbgs() { >&2 git msg; >&2 echo; pbgs_q; }
