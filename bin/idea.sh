#!/bin/bash

set -eu

usage() {
    echo "usage: $0 [-c|-u]"
    echo
    echo "        -c IntelliJ Community Edition"
    echo "        -u IntelliJ Ultimate Edition"
}

IDEA_INSTALLATIONS=$HOME/Downloads

IDEA_IC="idea-IC*"
IDEA_IU="idea-IU*"
FLAVOUR="$IDEA_IC"

if [ $# != 1 ] ; then
    usage
    exit 1
fi

while getopts "cu" opt ; do
    case $opt in
        c) FLAVOUR="$IDEA_IC" ;;
        u) FLAVOUR="$IDEA_IU*" ;;
    esac
done
shift `expr $OPTIND - 1`


LATEST=$(ls -1d $IDEA_INSTALLATIONS/$FLAVOUR | tail -1)

IDEA=$LATEST/bin/idea.sh
echo "Staring InjtelliJ IDEA: $IDEA"
exec $IDEA
