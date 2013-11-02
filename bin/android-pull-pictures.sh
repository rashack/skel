#!/bin/bash

LOCAL_BACKUP_ROOT=~/android/backup/pictures
REMOTE_BACKUP_ROOT=/sdcard/DCIM/Camera
BACKUP_LOG=$LOCAL_BACKUP_ROOT/$(date +%F_%T)-backup.log

for PICTURES in $(adb shell ls $REMOTE_BACKUP_ROOT | tr -d '\r') ; do
    LOCAL_BACKUP=$LOCAL_BACKUP_ROOT/$PICTURES
    REMOTE_BACKUP=$REMOTE_BACKUP_ROOT/$PICTURES
    if [ -f "$LOCAL_BACKUP" ] ; then
        echo "Backup $LOCAL_BACKUP already exists, skipping." >> $BACKUP_LOG
        continue
    fi
    echo "pulling new file $PICURES" >> $BACKUP_LOG
    adb pull $REMOTE_BACKUP $LOCAL_BACKUP
done
