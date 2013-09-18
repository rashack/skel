#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)

run_command () {
    echo "$YELLOW$1$NORMAL" >& 2
    eval $1
    ERR=$?
    if [ $ERR -ne 0 ] ; then
        echo "$1: ${RED}command failed with exit code $ERR$NORMAL"
        exit $?
    fi
}

check_add_ssh_key () {
    GIT_HOST=$(cat .git/config | grep "url \?= \?ssh://" | perl -pe 's|\s*url *= *ssh://([^/]+)/.*|$1|')
    echo $GIT_HOST
    if [ ! $(ssh-add -l | grep -q $GIT_HOST) ] ; then
        echo "${YELLOW}Couldn't find $GIT_HOST in ssh-agent, trying to add.${NORMAL}"
        HOST_KEY="~/.ssh/$GIT_HOST"
        if [ -f $HOST_KEY ] ; then
            echo "${RED}Couldn't find $HOST_KEY, giving up.${NORMAL}"
            exit 1;
        fi
        run_command "ssh-add $HOST_KEY"
    fi
}

check_add_ssh_key

git diff --quiet
STASH_NEEDED=$?
[ $STASH_NEEDED -eq 1 ] && run_command "git stash"
run_command "git pull --rebase"
run_command "git push"
[ $STASH_NEEDED -eq 1 ] && run_command "git stash pop"
echo "[ ${GREEN}OK${NORMAL} ]"
