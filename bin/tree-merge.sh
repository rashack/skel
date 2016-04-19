#!/bin/bash

set -eu

NO_OVERWRITE="--ignore-existing"

usage() {
    echo "usage: $(basename $0) SRC DST

    Merge content of directory SRC into directory DST.
    Files in SRC that are already in DST will not be moved.
"
}

merge() {
    SRC=$1
    DST=$2
    rsync --human-readable $NO_OVERWRITE --remove-source-files --archive $SRC/ $DST
}

do_test() {
    local tmpdir=$(mktemp -d)
    cd $tmpdir
    mkdir -p a/{x,y} b/{x,y}
    echo foo > a/x/foo
    echo bar > a/y/bar
    echo baz > b/y/baz
    echo bad > b/y/bar
    [ $(find a -type f | wc -l) == 2 ] || exit 1
    [ $(find b -type f | wc -l) == 2 ] || exit 1
    local before=$(find $tmpdir -type f | xargs md5sum | awk '{print $1}' | sort)
    merge $tmpdir/b $tmpdir/a
    local after=$(find $tmpdir -type f | xargs md5sum | awk '{print $1}' | sort)
    echo -e "before:\n$before"
    echo -e "after:\n$after"
    [ "$before" = "$after" ] || exit 1
    [ $(find a -type f | wc -l) == 3 ] || exit 1
    [ $(find b -type f | wc -l) == 1 ] || exit 1
    rm -rf $tmpdir/
}

while getopts "fht" opt ; do
    case $opt in
        f) NO_OVERWRITE="" ;;
        h) usage ; exit 0 ;;
        t) do_test ; exit 0 ;;
    esac
done
shift `expr $OPTIND - 1`

SRC=$1
DST=$2

if (( $# > 2 )) ; then
    echo "Too many parameters"
    exit 1
fi

merge $1 $2
