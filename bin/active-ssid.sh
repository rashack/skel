#!/bin/sh

DEV=$(/sbin/iw dev | sed -n 's/.*Interface \([a-z0-9]\+\).*/\1/p')

/sbin/iw dev $DEV link | sed -n 's/.*SSID: \(.*\)$/\1/ p'
