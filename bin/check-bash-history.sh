#!/bin/bash

BACKUP_BASE=.bash_history
BACKUP_DIR=~/$BACKUP_BASE.d
mkdir -p $BACKUP_DIR

PRES=$(wc -l ~/$BACKUP_BASE | awk '{print $1}')
PREV=$(wc -l $BACKUP_DIR/$BACKUP_BASE.0 | awk '{print $1}')

if [ $(( $PREV - $PRES )) -gt 0 ] ; then
    echo "Previous $BACKUP_BASE had $PREV rows and present has $PRES rows." >&2
    exit 1
fi

for (( i=${N_BASH_HISTORY_BACKUPS:-10} ; i > 0 ; i=i-1 )) ; do
    mv $BACKUP_DIR/$BACKUP_BASE.$(( $i-1 )) $BACKUP_DIR/$BACKUP_BASE.$i
done

cp ~/$BACKUP_BASE $BACKUP_DIR/$BACKUP_BASE.0
