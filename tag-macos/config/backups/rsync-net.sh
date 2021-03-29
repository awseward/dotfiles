#!/usr/bin/env bash

# Based on the following example:
# https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='rsync-net:borg-test'

# Load passphrase from MacOS keychain
export BORG_PASSCOMMAND="security find-generic-password -a ${USER} -s borg-passphrase -w"

# This needs to be set to use borg 1.X on rsync.net
export BORG_REMOTE_PATH='/usr/local/bin/borg1/borg1'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create              \
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

backup_exit=$?

info "Pruning repository"

borg prune                 \
    --list                 \
    --prefix '{hostname}-' \
    --show-rc              \
    --keep-daily    7      \
    --keep-weekly   4      \
    --keep-monthly  6      \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
