#!/bin/bash

SESSION=main

if [ $1 != "" ] ; then
    SESSION=$1
fi

if $(tmux ls -F"#{session_name}" | grep -q $SESSION) ; then
    tmux detach -s $SESSION
    tmux attach -t $SESSION
else
    tmux new -s $SESSION
fi
