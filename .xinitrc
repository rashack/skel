#!/bin/sh
xrdb -merge ~/.Xdefaults
xbindkeys
xscreensaver -nosplash &
imwheel
xsetroot -solid black

if [ `hostname` = "chimp" ] ; then
    xrandr --output DVI-I-1 --mode 2560x1440 --output DP-1 --mode 2560x1440  --right-of DVI-I-1
fi

[ $(lsusb | grep -q "Kinesis Advantage") ] || kinesis-x-mod

xmterm &

xmonad 2>&1 > $HOME/.xmonad/log.txt
