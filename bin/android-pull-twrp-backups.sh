#!/bin/bash

LOCAL_BACKUP_ROOT=~/android/backup
REMOTE_BACKUP_ROOT=/sdcard/TWRP/BACKUPS

# because stupid twrp names a directory with spaces
IFS='
'
# tr -d '\r' is needed because stupid 'adb shell ls' sends \r\n as EOL
for DIRS in $(adb shell ls $REMOTE_BACKUP_ROOT | tr -d '\r') ; do
    for BACKUPS in $(adb shell ls $REMOTE_BACKUP_ROOT/$DIRS | tr -d '\r') ; do
        LOCAL_BACKUP=$LOCAL_BACKUP_ROOT/$DIRS/$BACKUPS
        REMOTE_BACKUP=$REMOTE_BACKUP_ROOT/$DIRS/$BACKUPS
        if [ -d $LOCAL_BACKUP ] ; then
            echo "Backup $LOCAL_BACKUP already exists, skipping."
            continue
        fi
        mkdir -p $LOCAL_BACKUP
        echo "Starting pull from $REMOTE_BACKUP to $LOCAL_BACKUP"
        for FILES in $(adb shell ls $REMOTE_BACKUP | tr -d '\r') ; do
            echo "files = $FILES"
            FILE=$REMOTE_BACKUP/$FILES
            echo "pulling $FILE"
            adb pull $FILE $LOCAL_BACKUP
        done
    done
    cd $LOCAL_BACKUP
    md5sum -c *.md5
done
