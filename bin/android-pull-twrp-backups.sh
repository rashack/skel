#!/bin/bash

set -eu

LOCAL_BACKUP_ROOT=~/android/backup
REMOTE_BACKUP_ROOT=/sdcard/TWRP/BACKUPS

# because stupid twrp names a directory with spaces
IFS='
'

pull_backup() {
    echo "Starting pull from $REMOTE_BACKUP to $LOCAL_BACKUP"
    adb pull $REMOTE_BACKUP
}

# tr -d '\r' is needed because stupid 'adb shell ls' sends \r\n as EOL
DEVICE_BACKUP_DIR=$(adb shell ls $REMOTE_BACKUP_ROOT | tr -d '\r')
for BACKUP in $(adb shell ls $REMOTE_BACKUP_ROOT/$DEVICE_BACKUP_DIR | tr -d '\r') ; do
    LOCAL_BACKUP=$LOCAL_BACKUP_ROOT/$DEVICE_BACKUP_DIR
    REMOTE_BACKUP=$REMOTE_BACKUP_ROOT/$DEVICE_BACKUP_DIR/$BACKUP
    cd $LOCAL_BACKUP
    if [ -d "$LOCAL_BACKUP/$BACKUP" ] ; then
        echo "Backup $LOCAL_BACKUP already exists, skipping."
    else
        pull_backup
    fi
    echo "Checking MD5 sums"
    cd $BACKUP
    md5sum -c *.md5
done
