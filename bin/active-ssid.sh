#!/bin/sh

/sbin/iw dev wlan0 link | sed -n 's/.*SSID: \(.*\)$/\1/ p'
