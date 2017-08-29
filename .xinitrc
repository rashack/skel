#!/bin/bash

xscreensaver -nosplash &
xrdb -merge ~/.Xdefaults
xbindkeys
# Log an IN row in ~/.time
echo $(date +"%F_%T") IN >> ~/.time
imwheel
parcellite &
xsetroot -solid black

my-stalonetray.sh

case `hostname` in
    chimp)
	xrandr --output DVI-I-1 --mode 2560x1440 --output DP-1 --mode 2560x1440  --right-of DVI-I-1
        MOUSE_ID=$(xinput list | grep -i "ThinkPad USB Laser Mouse" | awk -F= '{ print $2}' | awk '{print $1}')
        #MOUSE_ID=$(xinput list | grep -i "ThinkPad USB Laser Mouse" | perl -pe 's/.*id=(\d+).*/$1/')
        xinput set-button-map $MOUSE_ID 1 2 3 4 5 8 9 6 7 10 11 12 13
	;;
    tp|bluetang|tubarao)
	setxkbmap -option -option ctrl:nocaps se
	synclient MaxTapTime=0
        nm-applet &
	;;
esac

if $(lsusb | grep -q "Kinesis Advantage") ; then kinesis-x-mod ; fi

xmterm &

exec xmonad 2>&1 > $HOME/.xmonad/log.txt
