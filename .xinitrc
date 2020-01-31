#!/bin/bash

xscreensaver -nosplash &
xrdb -merge ~/.Xdefaults
xbindkeys
# Log an IN row in ~/.time
echo $(date +"%F_%T") IN >> ~/.time
imwheel
parcellite &
xsetroot -solid black
# default: xset r rate 660 25
xset r rate 400 40

setxkbmap -option -option ctrl:nocaps se
case `hostname` in
    chimp)
        xrandr --output DP-1 --mode 2560x1440 --rotate normal --output DP-2 --pos 2560x0 --mode 2560x1440 --rotate left
        MOUSE_ID=$(xinput list | grep -i "ThinkPad USB Laser Mouse" | awk -F= '{ print $2}' | awk '{print $1}')
        #MOUSE_ID=$(xinput list | grep -i "ThinkPad USB Laser Mouse" | perl -pe 's/.*id=(\d+).*/$1/')
        xinput set-button-map $MOUSE_ID 1 2 3 4 5 8 9 6 7 10 11 12 13
	;;
    tp|bluetang)
	synclient MaxTapTime=0
        nm-applet &
	;;
    tubarao)
	synclient MaxTapTime=0 HorizHysteresis=0 VertHysteresis=0 MinSpeed=1.25 MaxSpeed=2
        nm-applet &
	;;
    reot)
        nm-applet &
        # disable two-finger horizontal scrolling
        # (libinput Scroll Method Enabled (292):   0, 0, 0)
        xinput set-prop 11 292 0 0 0
	;;
esac

if $(lsusb | grep -q "Kinesis Advantage") ; then kinesis-x-mod ; fi

xmterm &

exec xmonad 2>&1 > $HOME/.xmonad/log.txt
