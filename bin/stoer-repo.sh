#!/usr/bin/env bash

set -euo pipefail

source $HOME/.skel/lib/git-prompt-funs.sh

REPO_DIR=${REPO_DIR:-~/src/stoer}

maybe_update_repo() {
    local repo="$1"
    local tmp_dir=$2
    local lock_file=$3
    local tmp_stdout=$(mktemp $tmp_dir/stoer-repo.stdout.XXX)
    local tmp_stderr=$(mktemp $tmp_dir/stoer-repo.stderr.XXX)
    if [ -d "$repo" ] ; then
        cd "$repo"
        git remote update > $tmp_stdout 2> $tmp_stderr
        # if clean repo and on master branch
        if [ -z "$(git status --porcelain | grep -v '^\?')" ] && [ "$(git symbolic-ref --short HEAD)" = "master" ] ; then
            echo "$repo: clean, pulling" > $tmp_stdout 2> $tmp_stderr
            git merge --ff-only >$tmp_stdout 2> $tmp_stderr
        elif [ "$(git symbolic-ref --short HEAD)" = "master" ] ; then
            # try to merge on master anyway, might break
            echo "$repo: not clean, tring merge anyway" > $tmp_stdout 2> $tmp_stderr
            git merge --ff-only >$tmp_stdout 2> $tmp_stderr
        else
            echo "$repo: not clean or not on master, not merging" > $tmp_stdout 2> $tmp_stderr
        fi
    else
        echo "$repo: not a directory, ignoring" > $tmp_stdout 2> $tmp_stderr
    fi
    (
        flock -x 200
        cat $tmp_stdout | sed "s|.*|$repo stdout: &|"
        cat $tmp_stderr | sed "s|.*|$repo stderr: &|"
    ) 200> $lock_file
}

update_all_repos() {
    local repo_root="$1"
    local tmp_dir=$(mktemp -d /tmp/stoer-repo.XXX)
    local lock_file=$(mktemp /tmp/stoer-repo-lock.XXX)
    for repo in "$repo_root"/* ; do
        maybe_update_repo "$repo" $tmp_dir $lock_file &
    done
    wait
}

repo_status() {
    local repo=$1
    if [ -d $repo ] ; then
        cd $repo
        local name=$(basename $repo)
        local commit_date=$(git --no-pager log -n1 --pretty='format:%cs')
        local commit_author=$(git --no-pager log -n1 --pretty='format:%an' | awk '{print $1}')
        local commit_subject=$(git --no-pager log -n1 --pretty='format:%f')
        printf -- "%-36s %-24s %s %-16s %s\n" "$name" "$(___git_ps1)" "$commit_date" "$commit_author" "$commit_subject"
    else
        echo "$repo: not a directory"
    fi
}

repo_all_status() {
    local repo_root="$1"
    set +e
    for repo in $(list_repos "$repo_root" | sort) ; do
        repo_status $repo
    done
}

repo_all_full_status() {
    local repo_root="$1"
    set +e
    for repo in $(list_repos "$repo_root" | sort) ; do
        if [ -d $repo ] ; then
            cd $repo
            local name=$(basename $repo)
            if [ -z "$(git status --porcelain)" ]; then
                # Working directory clean
                printf -- "\e[1;32m%-36s\e[m %s\n" "$name" "$(___git_ps1)"
            else
                if [ -t ] ; then
                    printf -- '-%.0s' $(seq $(stty size | awk '{print $2}')); echo ""
                fi
                printf -- "\e[1;31m%-36s\e[m %s\n" "$name" "$(___git_ps1)"
                git status
            fi
        else
            echo "$repo: not a directory"
        fi
    done
}

list_repos() {
    local repo_dir="$1"
    find "$repo_dir" -maxdepth 4 -type d -name .git -exec dirname {} \;
}

while getopts "Ssux" opt ; do
    case $opt in
        x) set -x ;;
        s) repo_all_status "$REPO_DIR" ;;
        S) repo_all_full_status "$REPO_DIR" ;;
        u) update_all_repos "$REPO_DIR" ;;
    esac
done
shift `expr $OPTIND - 1`
