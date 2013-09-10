#!/bin/bash

TL=$(cat ~/.bash_history | wc -l)
PL=$(cat ~/.bash_history.0 | wc -l)

if [ $(( $PL - $TL )) -gt 1 ] ; then
    echo ".bash_history had $PL rows yesterday and $TL rows today." >&2
    exit 1
fi

cp -f .bash_history .bash_history.0
