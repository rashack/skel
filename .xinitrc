#!/bin/sh
xrdb -merge ~/.Xdefaults
xbindkeys
xscreensaver -nosplash &
imwheel
xsetroot -solid black

case `hostname` in
    chimp)
	xrandr --output DVI-I-1 --mode 2560x1440 --output DP-1 --mode 2560x1440  --right-of DVI-I-1
	;;
    baboon)
	setxkbmap -option -option ctrl:nocaps se
	;;
esac

if $(lsusb | grep -q "Kinesis Advantage") ; then kinesis-x-mod ; fi

xmterm &

xmonad 2>&1 > $HOME/.xmonad/log.txt
