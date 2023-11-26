#!/bin/bash

set -euo pipefail

TORRENT_DIR=$HOME/Downloads/torrents

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
    local TORRENT_NAME="$TORRENT_DIR/magnet-$filename.torrent"
    echo "Creating torrent: $TORRENT_NAME"
    echo "d10:magnet-uri${#1}:${1}e" > "$TORRENT_NAME"
}

while getopts "d:" opt ; do
    case $opt in
        d) TORRENT_DIR="$OPTARG" ;;
    esac
done
shift `expr $OPTIND - 1`

if [ $# -gt 0 ] ; then
    for x in $* ; do
        create_torrent "$x"
    done
elif [ $# -eq 0 ] ; then
    while true ; do
        read MAGNET_LINK
        if [ -z "$MAGNET_LINK" ] ; then
            exit 0
        fi
        create_torrent "$MAGNET_LINK"
    done
fi
