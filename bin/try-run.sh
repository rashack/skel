#!/bin/sh

source ~/bin/colours.sh

try_run () {
    local CMD="$*"
    echo "$COLY$CMD$COLN" >& 2
    eval $CMD
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$CMD: ${COLR}command failed with exit code $ERR$COLN"
        exit $ERR
    fi
}
