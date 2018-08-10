#!/bin/bash

set -euo pipefail

unset NEW_URL
unset REMOTE
REMOTE=$(git remote get-url origin)
NEW_URL=$(echo $REMOTE | perl -pe 's/git@git(lab|hub).com:/ssh:\/\/my-git\1\//g')

if [ -n "$NEW_URL" ] ; then
    git remote set-url origin "$NEW_URL"
else
    echo "Not a gitlab repo: $REMOTE"
    exit 1
fi
