#!/usr/bin/env bash

# Based on the following example:
# https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='ssh://rsync-net/./main'

# Load passphrase from MacOS keychain
export BORG_PASSCOMMAND="security find-generic-password -a ${USER} -s borg-passphrase -w"

# This needs to be set to use borg 1.X on rsync.net
export BORG_REMOTE_PATH='/usr/local/bin/borg1/borg1'

# Need to explicitly set this to `yes` if you ever move the location of the
# repo, otherwise should keep it set to `no` just in case of funny business.
#
# FWIW, I'm fairly certain `no` is the default, but no harm in being explicit
# in case that were ever to change.
export BORG_RELOCATED_REPO_ACCESS_IS_OK='no'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

# Need to consider potential alternatives to this.
eval "$(ssh-agent)" && ssh-add --apple-load-keychain

_hcio_uuid="$(cat ~/.config/backups/healthchecks.io.uuid)"; readonly _hcio_uuid
_hcio_run_id="$(uuidgen)"; readonly _hcio_run_id
# Set these up for calling at the end
hcio() { healthchecks.io.ping.sh "$@" "$_hcio_uuid" "$_hcio_run_id"; }

info_and_hcio() {
  local -r hcio_level="${1:-log}"
  local -r msg="$(cat -)"

  info "${msg}"
  hcio "${hcio_level}" <<< "${msg}"
}


# Try sending start signal; this is okay to fail (the `|| true` doesn't
# _actually_ matter without `set -e`, but I'm choosing to leave it in anyway)
info_and_hcio start <<< 'Starting backup'

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create \
    --verbose                             \
    --stats                               \
    --show-rc                             \
    --checkpoint-interval 300             \
    --exclude-caches                      \
    --pattern '! **/*[Cc]ache*'           \
    --pattern '! **/.git/objects'         \
    --pattern '! **/node_modules'         \
    --pattern '! /Users/*/.asdf/installs' \
    --pattern '! /Users/*/.espressif'     \
    --pattern '! /Users/*/.cache'         \
    --pattern '! /Users/*/.local/share'   \
    --pattern '! /Users/*/.vim/plugged'   \
    --pattern '! /Users/*/.stack'         \
    --pattern '! /Users/*/Library'        \
    --pattern '! /Users/*/VirtualBox VMs' \
                                          \
    --pattern '! /Users/*/Documents'      \
    --pattern '! /Users/*/Downloads'      \
    --pattern '! /Users/*/Desktop'        \
    --pattern '! /Users/*/Pictures'       \
    --pattern '! /Users/*/.Trash'         \
                                          \
    ::'{hostname}-{now}'                  \
    ~                                     \

backup_exit=$?

info_and_hcio <<< 'Pruning repository'

borg prune \
    --list                         \
    --glob-archives '{hostname}-*' \
    --show-rc                      \
    --keep-hourly   8              \
    --keep-daily    7              \
    --keep-weekly  12              \
    --keep-monthly 18              \
    && borg compact --verbose

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
  info_and_hcio success <<< 'Backup and Prune finished successfully'
elif [ ${global_exit} -eq 1 ]; then
  info_and_hcio log <<< 'Backup and/or Prune finished with warnings'
else
  # Not using `hcio failure` because we don't really need to cause
  # notifications for every single time the job fails, but would still like to
  # know about it.
  info_and_hcio log <<< 'Backup and/or Prune finished with errors'
fi

exit ${global_exit}
