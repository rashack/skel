#!/bin/bash

if [ $# = 0 ] ; then
    echo "usage: $0 STRING..."
    exit 1
fi

for x in *torrent ; do
    btshowmetainfo "$x" 2>&1 | grep -q "$*"
    if [[ $? == 0 ]] ; then
	echo $x
    fi
done | grep torrent
