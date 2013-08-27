#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)

run_command () {
    echo "$YELLOW$1$NORMAL" >& 2
    $1
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$1: ${RED}command failed with exit code $ERR$NORMAL"
        exit $?
    fi
}

run_command "git stash"
run_command "git pull --rebase"
run_command "git push"
run_command "git stash pop"
echo "[ ${GREEN}OK${NORMAL} ]"
