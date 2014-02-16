#!/bin/bash

TORRENT_DIR=/mnt/intel/torrents

create_torrent () {
    [[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit
    hashh=${BASH_REMATCH[1]}
    if [[ "$1" =~ dn=([^&/]+) ]];then
        filename=${BASH_REMATCH[1]}
    else
        filename=$hashh
    fi
    echo "d10:magnet-uri${#1}:${1}e" > "$TORRENT_DIR/meta-$filename.torrent"
}

for x in $* ; do
    create_torrent "$x"
done
