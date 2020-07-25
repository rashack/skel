#!/bin/sh

case $(hostname) in
    pringle)
        /home/kjell/bin/backup /home/kjell /mnt/backup/kjell
        /home/kjell/bin/backup /mnt/kjell /mnt/backup/kjell
        # /home/kjell/bin/backup_remote tp /home/kjell /home/kjell/.ssh/tp-backup
        ;;
    harc)
        /home/kjell/bin/backup /home/kjell /mnt/backup/kjell
        # /home/kjell/bin/backup /mnt/kjell /mnt/backup1/kjell
        ;;
esac
