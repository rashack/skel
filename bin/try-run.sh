#!/bin/sh

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)

try_run () {
    local CMD="$*"
    echo "$YELLOW$CMD$NORMAL" >& 2
    eval $CMD
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$CMD: ${RED}command failed with exit code $ERR$NORMAL"
        exit $ERR
    fi
}
