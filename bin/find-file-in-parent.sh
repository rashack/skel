#!/bin/bash

function ls-file () {
    ls $1/$2 2> /dev/null
}

# Find the location of file $1 in directory $2 or a parent of that directory.
# Ex. find-file-in-parent .git/config $PWD -> .git

find-file-in-parent() {
    local FILE=$1
    local DIR=$2
    local RES=$(ls-file $DIR $FILE)
    while [ -z $RES ] ; do
        if [ "$DIR" == "/" ] ; then
            return
        fi
        DIR=$(dirname $DIR)
        RES=$(ls-file $DIR $FILE)
    done
    echo $(dirname $RES)
}

find-file-in-parent $1 $2
