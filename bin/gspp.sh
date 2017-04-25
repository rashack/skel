#!/bin/bash

set -eu

source ~/bin/try-run.sh

get_git_host() {
    local URL=$(git remote get-url origin)
    local GIT_HOST=$(echo $URL | sed -n 's|ssh://\([^/]\+\)/.*|\1|p')
    if [ -z "$GIT_HOST" ] ; then
        GIT_HOST=$(echo $URL | sed -n 's|git@\([^:]\+\).*|\1|p')
    fi
    echo $GIT_HOST
}

check_add_ssh_key() {
    local GIT_HOST=$(get_git_host)
    if [ -z $GIT_HOST ] ; then
        echo "${COLR}Couldn't figure out git host.${COLN} Do you have a ssh://... in .git/config?"
        exit 1
    fi
    local HOST_KEY=$(sed -ne '/Host '$GIT_HOST'/,/^$/ p' ~/.ssh/config | \
	sed -ne 's/IdentityFile \(.*\)/\1/ p')
    HOST_KEY=${HOST_KEY/\~/$HOME}
    if ! ssh-add -l | grep -q $HOST_KEY ; then
        echo "${COLY}Couldn't find $GIT_HOST in ssh-agent, trying to add.${COLN}"
        if ! [ -f $HOST_KEY ] ; then
            echo "${COLR}Couldn't find $HOST_KEY, giving up.${COLN}"
            exit 1
        fi
        try_run "ssh-add $HOST_KEY"
    fi
}

check_add_ssh_key

STASH_NEEDED=1
if ! [ git diff --quiet ] ; then
    STASH_NEEDED=0
    try_run "git stash"
fi
try_run "git pull --rebase"
try_run "git push"
[ $STASH_NEEDED -eq 0 ] && try_run "git stash pop"
echo "[ ${COLG}OK${COLN} ]"
