#!/bin/bash

PLAYLIST_DIR=$HOME/music/playlists/

usage() {
    echo "usage: $0 PLAYLIST_NAME DIR"
}

if [ $# != 2 ] ; then
    usage
    exit 1
fi

NAME="$1"
DIR="$2"

find "$DIR" -type f -exec readlink -f {} \; | sort > $PLAYLIST_DIR/"$NAME".m3u
