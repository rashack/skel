#!/bin/sh
xrdb -merge ~/.Xdefaults
xbindkeys
xscreensaver -nosplash &
imwheel
xsetroot -solid black

#~/bin/xmod &
xmterm &

xmonad 2>&1 > $HOME/.xmonad/log.txt
