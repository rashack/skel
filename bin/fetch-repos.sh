#!/bin/bash

source ~/bin/try-run.sh
source ~/.repos-to-fetch

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
    cd
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        REPO_DIR=$(repo_dir $i)
        if [ -d $REPO_DIR ] ; then
            try_run "cd ~/$REPO_DIR"
            try_run "git fetch --all"
        else
            echo "$REPO_DIR: not there, not fetching"
        fi
    done
    cd -
}

clone_repos() {
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        REPO_DIR=$(repo_dir $i)
        REPO_URI=$(repo_uri $i)
        REPO_NAME=$(repo_name $i)
        try_run "cd ~/$(dirname $REPO_DIR)"
        if [ -d $(basename $REPO_DIR) ] ; then
            continue
        fi
        try_run "git clone $REPO_URI $REPO_NAME"
    done
}

shortstat_repos() {
    for (( i=0 ; i < $(no_repos) ; i=$i+1 )) ; do
        REPO_DIR=$(repo_dir $i)
        REPO_URI=$(repo_uri $i)
        REPO_NAME=$(repo_name $i)
        if [ -d ~/$REPO_DIR ] ; then
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

if [ $# -lt 1 ] ; then
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
