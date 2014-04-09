#!/bin/bash

if [[ $0 =~ "bin2" ]]; then
    IBASE="ibase=2"
elif [[ $0 =~ "dec2" ]]; then
    IBASE="ibase=10"
elif [[ $0 =~ "hex2" ]]; then
    IBASE="ibase=16"
fi

if [[ $0 =~ "2bin" ]] ; then
    OBASE="obase=2"
    BINARY_OUT=t
elif [[ $0 =~ "2dec" ]] ; then
    OBASE="obase=10"
elif [[ $0 =~ "2hex" ]] ; then
    OBASE="obase=16"
fi

convert() {
    local RES=$(echo "$OBASE;$IBASE;$(echo $1 | tr [a-z] [A-Z])" | bc)
    if [ -z $BINARY_OUT ] ; then
        echo $RES
    else
        printf "%0.8d" $RES
    fi
}

for x in "$@" ; do
    echo "$x: "$(convert $x)
done
