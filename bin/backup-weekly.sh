#!/bin/bash

RSYNC_OPTS="--archive --one-file-system --hard-links --human-readable \
--inplace --numeric-ids --delete --delete-excluded --exclude-from=$EXCLUDES -F --filter=':- .gitignore'"
BACKUP_SOURCE=/mnt/backup/
BACKUP_DEST=/mnt/weekly

run_command () {
    eval $1
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$1: command failed with exit code $ERR"
        exit $?
    fi
}

week_parity () {
    echo "scale=0; $(date +%V) % 2" | bc
}

run_command "mount LABEL=backup-$(week_parity) /mnt/weekly"
run_command "rsync $RSYNC_OPTS $BACKUP_SOURCE $BACKUP_DEST"
