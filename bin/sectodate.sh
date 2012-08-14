#!/bin/bash

if [ -z $1 ] ; then
    read TIME
else
    TIME=$1
fi

if [[ $0 =~ "msectodate" ]]; then
    TIME_IN_SEC=$(( $TIME / 1000 ))
else
    TIME_IN_SEC=$TIME
fi

echo $TIME_IN_SEC | gawk ' { print strftime ("%Y-%m-%d %H:%M:%S", $1) } '
