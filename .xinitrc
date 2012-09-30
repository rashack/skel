#!/bin/sh
xrdb -merge ~/.Xdefaults
xbindkeys
xscreensaver -nosplash &
imwheel
#xmms &
xsetroot -solid black
#xsetroot -solid black -display :0.1
#gkrellm --geometry +0+0 &
#xterm -fg gray -bg black -cr red -ls -sl 1024 -vb +sb \
#     -fn -misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-* &
#/usr/bin/nvidia-settings --load-config-only

#~/bin/xmod &
~/bin/caps-away
xmterm &

xmonad 2>&1 > $HOME/.xmonad/log.txt
