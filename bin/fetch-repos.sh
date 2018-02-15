#!/bin/bash

set -eu

source ~/bin/try-run.sh

repo_name() {
    echo ${REPOS[$(( $1 * 3 + $REPO_NAME_IDX ))]}
}

repo_dir() {
    echo ${REPOS[$(( $1 * 3 + $REPO_DIR_IDX ))]}
}

repo_uri() {
    echo ${REPOS[$(( $1 * 3 + $REPO_REMOTE_IDX ))]}
}

no_repos() {
    echo $(( ${#REPOS[@]} / $REPO_ELEMENTS ))
}


fetch_repos() {
    pushd .
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        local REPO_NAME=$(repo_name $i)
        local REPO_DIR=$(repo_dir $i)
        local DIR="$REPO_DIR/$REPO_NAME"
        cd
        if [ -d $DIR ] ; then
            try_run "cd ~/$DIR"
            try_run "git fetch --all"
        else
            echo "$DIR: not there, not fetching"
        fi
    done
    popd
}

clone_repos() {
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        local REPO_NAME=$(repo_name $i)
        local REPO_DIR=$(repo_dir $i)
        local REPO_URI=$(repo_uri $i)
        if ! [ -d "$REPO_DIR" ] ; then
            try_run "mkdir -p $REPO_DIR"
        fi
        try_run "cd $REPO_DIR"
        if [ -d $(basename "$REPO_DIR/$REPO_NAME") ] ; then
            continue
        fi
        try_run "git clone $REPO_URI $REPO_NAME"
    done
}

shortstat_repos() {
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        local REPO_NAME=$(repo_name $i)
        local REPO_DIR=$(repo_dir $i)
        local REPO_URI=$(repo_uri $i)
        if [ -d $REPO_DIR ] ; then
            try_run "cd ~/$REPO_DIR"
            git status -sb | head -1
        else
            echo "$REPO_NAME: not cloned"
        fi
    done
}

usage() {
    echo "usage: $(basename $0) OPTION

    OPTION
        -c    clone repos and fetch existing ones
        -f    fetch existing repos
        -s    print short status for repos
"
}

if [ $# -eq 2 ] && [ -f "$1" ] ; then
    source "$1"
    shift
elif [ $# -eq 1 ] ; then
    source ~/.repos-to-fetch
else
    usage
    exit 1
fi

while getopts "cfs" opt ; do
    case $opt in
        c) clone_repos ;;
        f) fetch_repos ;;
        s) shortstat_repos ;;
    esac
done
shift `expr $OPTIND - 1`
