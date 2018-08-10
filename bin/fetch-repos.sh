#!/bin/bash

set -euo pipefail

source ~/bin/try-run.sh

repo_name() {
    echo ${REPOS[$(( $1 * 3 + $REPO_NAME_IDX ))]}
}

repo_dir() {
    local I=$1
    echo ${REPOS[$(( $I * 3 + $REPO_DIR_IDX ))]}/${REPOS[$(( $I * 3 + $REPO_NAME_IDX ))]}
}

repo_uri() {
    echo ${REPOS[$(( $1 * 3 + $REPO_REMOTE_IDX ))]}
}

repo_count() {
    echo $(( ${#REPOS[@]} / $REPO_ELEMENTS ))
}

is_git_repo() {
    local dir=$1
    pushd . 2>&1 > /dev/null
    cd $dir
    git rev-parse --git-dir >/dev/null 2>&1
    local res=$?
    popd 2>&1 > /dev/null
    return $res
}

list_repos() {
    for (( i=0 ; i < ${#REPO_DIRS[@]} ; i=i+1 )) ; do
        local repo_dir=${REPO_DIRS[$i]}
        for d in $(find $repo_dir -maxdepth 1 -type d) ; do
            if is_git_repo $d ; then
                echo + $d
            else
                echo - $d
            fi
        done
    done | sort
}

fetch_repos() {
    pushd .
    for (( i=0 ; i < $(repo_count) ; i=$i+1 )) ; do
        local REPO_DIR=$(repo_dir $i)
        cd
        if [ -d $REPO_DIR ] ; then
            try_run "cd $REPO_DIR"
            try_run "git fetch --all"
        else
            echo "$REPO_DIR: not there, not fetching"
        fi
    done
    popd
}

clone_repos() {
    for (( i=0 ; i < $(repo_count) ; i=$i+1 )) ; do
        local REPO_NAME=$(repo_name $i)
        local REPO_DIR=$(repo_dir $i)
        local REPO_URI=$(repo_uri $i)
        if ! [ -d $(dirname "$REPO_DIR") ] ; then
            echo "$(dirname "$REPO_DIR"): does not exist, not cloning $REPO_NAME"
            continue
        fi
        if [ -d "$REPO_DIR" ] ; then
            echo "$REPO_DIR: exists, not cloning $REPO_NAME"
            continue
        fi
        try_run "cd $(dirname $REPO_DIR)"
        try_run "git clone $REPO_URI $REPO_NAME"
    done
}

shortstat_repos() {
    for (( i=0 ; i < $(repo_count) ; i=$i+1 )) ; do
        local REPO_NAME=$(repo_name $i)
        local REPO_DIR=$(repo_dir $i)
        local REPO_URI=$(repo_uri $i)
        if [ -d $REPO_DIR ] ; then
            cd $REPO_DIR
            echo "$REPO_DIR: $(git status -sb | head -1)"
        else
            echo "$REPO_DIR: not cloned"
        fi
    done | column -t
}

usage() {
    echo "usage: $(basename $0) OPTION

    OPTION
        -c    clone non-existing repos
        -f    fetch/update existing repos
        -l    list repos in repo directories
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

while getopts "cflsx" opt ; do
    case $opt in
        c) clone_repos ;;
        f) fetch_repos ;;
        l) list_repos ;;
        s) shortstat_repos ;;
        x) set -x ;;
    esac
done
shift `expr $OPTIND - 1`
