#!/bin/bash

TMP=$(mktemp --suffix=.png)
scrot -s $TMP

xclip -selection clipboard -t image/png -i $TMP

notify-send "Screenshot copied to clipboard"
