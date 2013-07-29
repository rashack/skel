#!/bin/sh
xrdb -merge ~/.Xdefaults
xbindkeys
xscreensaver -nosplash &
imwheel
xsetroot -solid black

if [ `hostname` = "kjelldesktop" ] ; then
    xrandr --output HDMI2 --mode 1920x1200  --left-of HDMI1
fi

#~/bin/xmod &
xmterm &

xmonad 2>&1 > $HOME/.xmonad/log.txt
