#!/bin/bash

set -euo pipefail

BASE64=false
N_CHARS=16

while getopts "Aabl:nsw:" opt ; do
    case $opt in
        A) CHARS="" ;;
        a) CHARS="${CHARS-}a-zA-Z" ;; # 50
        b) BASE64=true ;;
        l) N_CHARS=$OPTARG ;;
        n) CHARS="${CHARS-}0-9" ;; # 10
        s) CHARS="${CHARS-}~!@#$%^&*_-" ;; # 11
        w) WIDTH=$OPTARG
    esac
done
shift `expr $OPTIND - 1`

CHARS=${CHARS-:'a-zA-Z0-9~!@#$%^&*_-'}

LC_ALL=C

if [ $BASE64 = "true" ] ; then
    head -c $N_CHARS /dev/urandom | base64
else
    head -c 500 /dev/urandom | tr -dc "$CHARS" | fold -w "$N_CHARS"
fi
echo
