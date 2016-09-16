#!/bin/bash

source ~/bin/try-run.sh

check_add_ssh_key () {
    local GIT_HOST=$(git remote get-url origin | \
	perl -pe 's|ssh://([^/]+)/.*|$1|')
    if [ -z $GIT_HOST ] ; then
        echo "${RED}Couldn't figure out git host.${NORMAL} Do you have a ssh://... in .git/config?"
        exit 1
    fi
    local HOST_KEY=$(sed -ne '/Host '$GIT_HOST'/,/^$/ p' ~/.ssh/config | \
	sed -ne 's/IdentityFile \(.*\)/\1/ p')
    HOST_KEY=${HOST_KEY/\~/$HOME}
    if ! ssh-add -l | grep -q $HOST_KEY ; then
        echo "${YELLOW}Couldn't find $GIT_HOST in ssh-agent, trying to add.${NORMAL}"
        if ! [ -f $HOST_KEY ] ; then
            echo "${RED}Couldn't find $HOST_KEY, giving up.${NORMAL}"
            exit 1
        fi
        try_run "ssh-add $HOST_KEY"
    fi
}

check_add_ssh_key

git diff --quiet
STASH_NEEDED=$?
[ $STASH_NEEDED -eq 1 ] && try_run "git stash"
try_run "git pull --rebase"
try_run "git push"
[ $STASH_NEEDED -eq 1 ] && try_run "git stash pop"
echo "[ ${GREEN}OK${NORMAL} ]"
