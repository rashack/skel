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

try_run_fancy() {
    if (( $# > 1 )) ; then
        local CMD=${@:2}
        echo "$COLY$CMD$COLN" >& 2
        local WIDTH=$(( $(tput cols) + 8 ))
    else
        local CMD=$@
        echo -n "$COLY$CMD$COLN" >& 2
        local WIDTH=$(( $(tput cols) - ${#CMD} + 8 ))
    fi

    eval $CMD
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$CMD: ${COLR}command failed with exit code $ERR$COLN" >& 2
        exit $ERR
    else
        printf "%${WIDTH}s\n" "[ ${COLG}OK${COLN} ]" >& 2
    fi
}
