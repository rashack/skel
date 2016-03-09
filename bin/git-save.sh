#!/bin/bash

BCK=/tmp/${PWD////_}.tar
if [ -f $BCK ] ; then
    echo "$BCK: archive already exists"
    exit 1
else
    git ls-files --others --exclude-standard -z | xargs -0 tar rvf $BCK
    echo "$BCK: backup archive created"
fi
