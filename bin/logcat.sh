#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Package name required."
    exit 1
fi

PACKAGE=$1

APP_PID=$(adb -d shell ps | grep "$PACKAGE" | awk '{print $2}')
if [ -z "$APP_PID" ] ; then
    echo "$PACKAGE: no process from package found, is the app running?"
    exit 1
fi

logcat() {
    adb -d logcat -v long | tr -d '\r' | \
        sed -e '/^\[.*\]/ {N; s/\n/ /}' | grep -v '^$' | \
        grep " ${APP_PID}:"
}
logcat
