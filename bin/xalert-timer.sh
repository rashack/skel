#!/bin/sh

if [ "$#" -lt 1 ] ; then
    echo "$0: number of seconds to countdown needed"
    exit 1
fi

sleep $1 ; echo -n '\a'
