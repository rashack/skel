#!/bin/bash

if [[ ! -d $1 || ! -d $2 ]] ; then
    echo "Both parameters must be directories."
    exit 1
fi

function full_path {
    echo $(cd $1 ; pwd)
}

TMP_D1=/tmp/dirdiff-d1-$$
TMP_D2=/tmp/dirdiff-d2-$$
ROOT_A=$(full_path "$1")
ROOT_B=$(full_path "$2")

find $ROOT_A -path "*/.git" -prune -o -path "*/.svn" -o -path "*/.hg" -prune -o -type f -print0 | xargs -0 md5sum > $TMP_D1 &
PID1=$!
find $ROOT_B -path "*/.git" -prune -o -path "*/.svn" -o -path "*/.hg" -prune -o -type f -print0 | xargs -0 md5sum > $TMP_D2 &
PID2=$!

for pid in $PID1 $PID2 ; do
    wait $pid
done

cat $TMP_D1 $TMP_D2 | sort | uniq -w32 -c | tr -s ' ' | grep -v "^ 2" | grep -v \\.git \
    | perl -pe 's/\s+(\S+)\s+(\S+)\s+(.*)/\3\t\1\t\2/g'
