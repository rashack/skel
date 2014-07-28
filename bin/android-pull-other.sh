#!/bin/bash

LOCAL_BACKUP_ROOT=~/android/backup/other
REMOTE_BACKUP_ROOT=/sdcard
REMOTE_BACKUP_DIRS="Kik Download Kjell Pictures"
BACKUP_LOG=$LOCAL_BACKUP_ROOT/$(date +%F_%T)-backup-other.log

for DIR in $REMOTE_BACKUP_DIRS ; do
    LDIR=$LOCAL_BACKUP_ROOT/$DIR
    RDIR=$REMOTE_BACKUP_ROOT/$DIR
    mkdir -p $LDIR
    OLD_IFS=$IFS
    IFS=$(echo -en "\n\b")
    for FILE in $(adb shell ls $RDIR | tr -d '\r') ; do
        LFILE=$LDIR/$FILE
        RFILE=$RDIR/$FILE
        if [ -f "$LFILE" ] ; then
            echo "Backup $LFILE already exists, skipping." >> $BACKUP_LOG
            continue
        fi
        echo "pulling new file $RFILE" >> $BACKUP_LOG
        eval "adb pull \"$RFILE\" \"$LFILE\""
    done
    IFS=$OLD_IFS
done
