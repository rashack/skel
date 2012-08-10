#!/bin/bash

pgrep xssw.pl > /dev/null
if [ 0 != $? ] ; then
    ~/bin/xssw.pl &
fi
