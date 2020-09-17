#!/usr/bin/env bash

# To run:
# slaskit.sh ~/src/stoer/slask file1 file2 ...

if ! [ -d "$1" ] ; then
    echo "First parameter must be a directory (destination)"
    exit 1
fi

DEST=$1
shift


for file in $* ; do
    echo $file
    ffile=$(readlink -f $file)
    home_path=${ffile#$HOME}
    dir=$DEST/$(dirname $home_path)
    mkdir -p $dir
    mv $file $dir
done
