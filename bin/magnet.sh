#!/bin/bash

TORRENT_DIR=/mnt/intel/torrents

usage() {
    echo -e "Usage:

    $(basename $0) [-d TARGET_DIR] MAGNET_STRING\n"
}

create_torrent () {
    [[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit
    hashh=${BASH_REMATCH[1]}
    if [[ "$1" =~ dn=([^&/]+) ]];then
        filename=${BASH_REMATCH[1]}
    else
        filename=$hashh
    fi
    echo "d10:magnet-uri${#1}:${1}e" > "$TORRENT_DIR/magnet-$filename.torrent"
}

if [ $# -lt 1 ] ; then
    usage
    exit 1
fi

while getopts "d:" opt ; do
    case $opt in
        d) TORRENT_DIR="$OPTARG" ;;
    esac
done
shift `expr $OPTIND - 1`

for x in $* ; do
    create_torrent "$x"
done
