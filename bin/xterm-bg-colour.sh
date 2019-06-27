#!/bin/bash

if [[ $TERM =~ "xterm" ]] ; then
    success=false
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    col=11      # background
    #          OSC   Ps  ;Pt ST
    echo -en "\e]${col};?\e\\" >/dev/tty  # echo opts differ w/ OSes
    #printf "\044]${col};?\033\\" >/dev/tty
    result=
    if IFS=';' read -r -d '\' color ; then
        result=$(echo $color | sed 's/^.*\;//;s/[^rgb:0-9a-f/]//g')
        success=true
    fi
    stty $oldstty
    echo $result
    $success
else
    echo "rgb:0000/0000/0000"
fi



# oldstty=$(stty -g)

# stty raw -echo min 0 time 0
# # stty raw -echo min 0 time 1
# printf "\033]11;?\033\\"
# # xterm needs the sleep (or "time 1", but that is 1/10th second).
# sleep 0.00000001
# read -r answer
# # echo $answer | cat -A
# result=${answer#*;}
# stty $oldstty
# # Remove escape at the end.
# echo $result | sed 's/[^rgb:0-9a-f/]\+$//'
