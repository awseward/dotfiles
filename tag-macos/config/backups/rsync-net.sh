#!/usr/bin/env bash

# Based on the following example:
# https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='rsync-net:main'

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

# Send start signal
hcio start <<< ''

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create \
    --verbose            \
    --list               \
    --stats              \
    --show-rc            \
    --exclude-caches     \
                         \
    ::'{hostname}-{now}' \
                         \
    ~/books              \
    ~/scans              \
    ~/uncategorized      \
    ~/stale_downloads    \

backup_exit=$?

info "Pruning repository"

borg prune \
    --list                         \
    --glob-archives '{hostname}-*' \
    --show-rc                      \
    --keep-hourly   8              \
    --keep-daily    7              \
    --keep-weekly  12              \
    --keep-monthly 18              \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

hcio_exit $global_exit

if [ ${global_exit} -eq 0 ]; then
  info 'Backup and Prune finished successfully'
  hcio success <<< ''
elif [ ${global_exit} -eq 1 ]; then
  msg='Backup and/or Prune finished with warnings'
  info "$msg"
  hcio log <<< "$msg"
else
  msg='Backup and/or Prune finished with errors'
  info "$msg"
  # Not using `hcio failure` because we don't really need to cause
  # notifications for every single time the job fails, but would still like to
  # know about it.
  hcio log <<< "$msg"
fi

exit ${global_exit}
