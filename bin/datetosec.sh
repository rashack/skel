#!/bin/bash

if [ -z "$1" ] ; then
    read TIME
else
    TIME=$@
fi

TIME_IN_SEC=$(echo $TIME | awk "{ print strftime (\"%s\", mktime (\"$*\")) ; fflush() }")

if [[ $0 =~ "datetomsec" ]]; then
    echo $(( $TIME_IN_SEC * 1000 ))
else
    echo $TIME_IN_SEC
fi
