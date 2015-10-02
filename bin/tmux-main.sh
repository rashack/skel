#!/bin/bash

if [ $(tmux ls -F"#{session_name}" | grep main) == "main" ] ; then
    tmux detach -s main
    tmux attach -t main
else
    tmux new -s main
fi
