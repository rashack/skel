#!/usr/bin/env bash

set -euo pipefail

source $HOME/.skel/lib/git-prompt-funs.sh

REPO_DIR=${REPO_DIR:-~/src/stoer}

CRED=$(tput setaf 1)
CGRE=$(tput setaf 2)
CYEL=$(tput setaf 3)
CCLR=$(tput sgr0)

maybe_update_repo() {
    local repo="$1"
    local tmp_dir="$2"
    local lock_file="$3"
    local tmp_stdout=$(mktemp $tmp_dir/stoer-repo.stdout.XXX)
    local tmp_stderr=$(mktemp $tmp_dir/stoer-repo.stderr.XXX)
    if [ -d "$repo" ] ; then
        cd "$repo"
        git remote update > $tmp_stdout 2> $tmp_stderr
        err1=$?
        if ! [ $(git remote get-url origin >& /dev/null) ] ; then
            echo "No remote url for 'origin' set ('git remote get-url origin' failed)" > $tmp_stdout 2> $tmp_stderr
            err2=3
        else
            # if clean repo and on master branch
            if [ -z "$(git status --porcelain | grep -v '^\?')" ] && [[ "$(git symbolic-ref --short HEAD)" =~ "main|master" ]] ; then
                echo "$repo: clean, pulling" > $tmp_stdout 2> $tmp_stderr
                git merge --ff-only >$tmp_stdout 2> $tmp_stderr
                err2=$?
            elif [ "$(git symbolic-ref --short HEAD)" =~ "main|master" ] ; then
                # try to merge on master anyway, might break
                echo "$repo: not clean, trying merge anyway" > $tmp_stdout 2> $tmp_stderr
                git merge --ff-only >$tmp_stdout 2> $tmp_stderr
                err2=$?
            else
                echo "dirty or on topic branch, no merge" > $tmp_stdout 2> $tmp_stderr
                err2=1
            fi
        fi
    else
        echo "$repo: not a directory, ignoring" > $tmp_stdout 2> $tmp_stderr
        err1=1
        err2=1
    fi
    if [ $err1 == 0 ] && [ $err2 == 0 ] ; then
        color=$(tput setaf 2)
    elif [ $err2 == 3 ] ; then
        color=$(tput setaf 3)
    else
        color=$(tput setaf 1)
    fi
    local short_repo=$(printf "$color%-6s %-40s$(tput sgr0)" "[$err1 $err2]" "${repo#$REPO_DIR/}")
    (
        #flock -x 200
        cat $tmp_stdout | sed "s|.*|$short_repo stdout: &|"
        cat $tmp_stderr | sed "s|.*|$short_repo stderr: &|"
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

maybe_update_repo_parallel() {
    # set the first variable "to be split into variables"
    set $1
    local repo="$1"
    local repo_name="$2"
    local tmp_stdout="$3"
    local tmp_stderr="$4"
    local t0=$EPOCHSECONDS
    #echo "$repo - $repo_name - $tmp_stdout - $tmp_stderr"
    if [ -d "$repo" ] ; then
        cd "$repo"
        git remote update > $tmp_stdout 2> $tmp_stderr
        err1=$?
        local mbranch=$(git branch | grep -Eo "main|master")
        if ! $(git remote get-url origin >& /dev/null) ; then
            echo "No remote url for 'origin' set ('git remote get-url origin' failed)" > $tmp_stdout 2> $tmp_stderr
            err2=3
        else
            # if clean repo and on main/master branch
            if [ -z "$(git status --porcelain | grep -v '^\\?')" ] && [[ "$(git symbolic-ref --short HEAD)" =~ "main"|"master" ]] ; then
                echo "$repo_name: clean, pulling" > $tmp_stdout
                git merge --ff-only >$tmp_stdout 2> $tmp_stderr
                err2=$?
            # on main/master but not clean
            elif [[ "$(git symbolic-ref --short HEAD)" =~ "main"|"master" ]] ; then
                # try to merge on master anyway, might break
                echo "$repo_name: not clean, trying merge anyway" > $tmp_stdout
                git merge --ff-only >$tmp_stdout 2> $tmp_stderr
                err2=$?
            # on topic branch, but origin/main == main
            elif [ -z "$(git diff --shortstat $mbranch origin/$mbranch)" ] ; then
                echo "on topic branch, but origin/main == main" > $tmp_stdout
                err2=3
            else
                echo "dirty or on topic branch, no merge" > $tmp_stdout
                err2=1
            fi
        fi
    else
        echo "$repo_name: not a directory, ignoring" > $tmp_stdout
        err1=1
        err2=1
    fi
    if [ $err1 == 0 ] && [ $err2 == 0 ] ; then
        color=$(tput setaf 2)
    elif [ $err2 == 3 ] ; then
        color=$(tput setaf 3)
    else
        color=$(tput setaf 1)
    fi
    local t1=$EPOCHSECONDS
    local tt=$(( $t1 - $t0 ))
    #local short_repo=$(printf "$color%-6s %-40s$(tput sgr0)" "[$err1 $err2]" "${repo#$REPO_DIR/}")
    local short_repo=$(printf "$color%-6s %-40s$(tput sgr0)" "[$err1 $err2]" "$repo_name")
    cat $tmp_stdout | sed "s|.*|(${tt}s) $short_repo stdout: &|"
    cat $tmp_stderr | sed "s|.*|$short_repo $(tput setaf 1)stderr$(tput sgr0): &|"
}

update_all_repos_parallel() {
    local repo_root="$1"
    local tmp_dir=$(mktemp -d /tmp/stoer-repo.XXX)
    local repos
    local repo_dirs
    local tmp_stdouts
    local tmp_stderrs
    #readarray -t repos <(ls -1 $repo_root | sort)
    if [ -n "$REPO_LIST" ] ; then
        echo $REPO_LIST
        for repo in $(list_repos "$repo_root" | sort) ; do
            if [ -d "$repo/.git" ] ; then
                local repo_name=$(basename "$repo")
                local stdout_file=$(mktemp "$tmp_dir/$repo_name.stdout.XXX")
                local stderr_file=$(mktemp "$tmp_dir/$repo_name.stderr.XXX")
                repos+=("$repo $repo_name $stdout_file $stderr_file")
            fi
        done
    else
        for repo in $(list_repos "$repo_root" | sort) ; do
            if [ -d "$repo/.git" ] ; then
                local repo_name=$(basename "$repo")
                local stdout_file=$(mktemp "$tmp_dir/$repo_name.stdout.XXX")
                local stderr_file=$(mktemp "$tmp_dir/$repo_name.stderr.XXX")
                #echo "$repo $repo_name $stdout_file $stderr_file"
                #repos+=("$repo")
                #repo_dirs+=("$repo_name")
                #tmp_stdouts+=("$stdout_file")
                #tmp_stderrs+=("$stderr_file")
                repos+=("$repo $repo_name $stdout_file $stderr_file")
            fi
        done
    fi
    # export function so 'parallel' can use it
    export -f maybe_update_repo_parallel
    # poopy shit macos needs, maybe, something like:
    # sudo launchctl limit maxfiles 10240 200000
    # and/or:
    # ulimit -n 10240
    # and more than 10240 might not work as expected, and be ignored instead
    #parallel -j0 -N 100 --pipe parallel -j0 -k maybe_update_repo_parallel {} ::: "${repos[@]}"
    parallel -j 50 -k maybe_update_repo_parallel {} ::: "${repos[@]}"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    export TODAY=$(gdate +%s)
else
    export TODAY=$(date +%s)
fi
commit_age_days() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local date=$(gdate -d "$1" +%s)
    else
        local date=$(date -d "$1" +%s)
    fi
    echo $(( (TODAY - date) / 86400 ))
}
export -f commit_age_days

COLOURS=(
    "\033[38;5;196m"
    "\033[38;5;202m"
    "\033[38;5;208m"
    "\033[38;5;214m"
    "\033[38;5;220m"
    "\033[38;5;226m"
    "\033[38;5;51m"
    "\033[38;5;45m"
    "\033[38;5;39m"
    "\033[38;5;33m"
    "\033[38;5;27m"
    "\033[38;5;21m"
)

# foo=3
# echo -e "${COLOURS[$foo]}text $foo\033[0m"
# foo=10
# echo -e "${COLOURS[$foo]}text $foo\033[0m"

echo_colour() {
    local days=$1
    local text="$2"
    local months=$(( days / 30 ))
    if [ $months -gt 11 ] ; then
        months=11
    fi
    echo -ne "${COLOURS[$months]}${text}\033[0m"
}
export -f echo_colour

# age=$(commit_age_days 2022-01-24)
# r=$(echo_colour $age foo$age)
# printf -- "%s\n" "$r"

# age=$(commit_age_days 2022-10-24)
# r=$(echo_colour $age foo$age)
# printf -- "%s\n" "$r"

# age=$(commit_age_days 2022-06-24)
# r=$(echo_colour $age foo$age)
# printf -- "%s\n" "$r"

repo_status() {
    local repo=$1
    if [ -d $repo ] ; then
        cd $repo
        local name=$(basename $repo)
        local commit_date=$(git --no-pager log -n1 --pretty='format:%cs')
        local age_days=$(commit_age_days $commit_date)
        local coloured_commit_date=$(echo_colour $age_days $commit_date)
        local commit_author=$(git --no-pager log -n1 --pretty='format:%an' | awk '{print $1}')
        local commit_subject=$(git --no-pager log -n1 --pretty='format:%f')
        local git_ps1=$(___git_ps1)
        if [ "$STATUS_TIME_SORT" == "true" ] ; then
            printf -- "%s %-40s %-24s %-12s %s\n" "$coloured_commit_date" "$name" "$git_ps1" "$commit_author" "$commit_subject"
        else
            printf -- "%-36s %-24s %s %-16s %s\n" "$name" "$git_ps1" "$coloured_commit_date" "$commit_author" "$commit_subject"
        fi
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

repo_all_status_parallel() {
    local repo_root="$1"
    set +e
    local tmp_repo_names=$(mktemp /tmp/stoer-repos.XXX)
    list_repos "$repo_root" > $tmp_repo_names
    #ignore_repos "$repo_root" > $tmp_repo_names
    export -f repo_status
    export -f ___git_ps1 __git_sequencer_status __git_eread __git_ps1_show_upstream
    parallel repo_status < $tmp_repo_names | sort
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

CRED=$(tput setaf 1)
CGRE=$(tput setaf 2)
CYEL=$(tput setaf 3)
CCLR=$(tput sgr0)

repo_all_eval() {
    local repo_root="$1"
    local repo_cmd="$2"
    set +e
    for repo in $(list_repos "$repo_root" | sort) ; do
        if [ -d $repo ] ; then
            echo "$CYEL$repo: evaluating '$repo_cmd'$CCLR"
            cd $repo
            $repo_cmd
        else
            echo "$repo: not a directory"
        fi
    done
}

list_repos() {
    local repo_dir="$1"
    find "$repo_dir" -maxdepth 4 -type d -name .git -exec dirname {} \;
}

ignore_repos() {
    local all=$(list_repos "$1")
    local some=()
    local ignored=(mosaic interest-comparison-api bosam-front broqr checkin-api)
    for repo in $all ; do
        if [[ ! " ${ignored[*]} " =~ " ${repo} " ]]; then
            some+=($repo)
        fi
    done
    echo "${some[@]}"
}

PARALLEL="true"
REPO_LIST=""
export STATUS_TIME_SORT="false"

if ! [[ "$1" =~ ^-. ]] ; then
    CMD="$1"
    shift
fi

while getopts "pr:R:tx" opt ; do
    case $opt in
        p) PARALLEL="false" ;;
        r) REPO_DIR="$OPTARG" ;;
        R) REPO_LIST="$OPTARG" ;;
        t) export STATUS_TIME_SORT="true" ;;
        x) set -x ;;
    esac
done
shift `expr $OPTIND - 1`

CMD=${CMD:-$1}

case $CMD in
    "eval")
        repo_all_eval "$REPO_DIR" "$1"
        exit
        ;;
    status)
        if [ $PARALLEL == "true" ] ; then
            repo_all_status_parallel "$REPO_DIR"
        else
            repo_all_status "$REPO_DIR"
        fi
        ;;
    full-status)
        repo_all_full_status "$REPO_DIR"
        exit
        ;;
    update)
        if [ $PARALLEL == "true" ] ; then
            update_all_repos_parallel "$REPO_DIR"
        else
            update_all_repos "$REPO_DIR"
        fi
        ;;
esac
