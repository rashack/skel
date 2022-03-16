#!/bin/bash

set -euo pipefail

DRY_RUN=n
while getopts "d" opt ; do
    case $opt in
        d)
            set -x
            DRY_RUN=y ;;
    esac
done
shift `expr $OPTIND - 1`

unset NEW_URL
unset REMOTE
REMOTE=$(git remote get-url origin)
NEW_URL=$(echo $REMOTE | perl -pe 's/git\@git(lab|hub).com:/ssh:\/\/my-git\1\//g')

if [ -n "$NEW_URL" ] ; then
    if [ "x$DRY_RUN" = "xy" ] ; then
        echo "Dry run: 'git remote set-url origin $NEW_URL'"
    else
        git remote set-url origin "$NEW_URL"
    fi
else
    echo "Not a gitlab repo: $REMOTE"
    exit 1
fi
