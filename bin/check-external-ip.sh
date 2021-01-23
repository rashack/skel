#!/bin/bash

set -euo pipefail

EMAIL=$(cat ~/.email)

EXTERNAL_IP_LOG=~/.external-ip
LOG=~/.external-ip.log
CMD="curl -s ipecho.net/plain"

LAST=$(tail -1 $EXTERNAL_IP_LOG | awk '{print $4}')
CURR=$($CMD)

log() {
    local log_file="$1"
    echo "$(date '+%F %T') -- $2" >> $log_file
}

is_ip() {
    echo $1 | grep -P "^(\d{1,3}\.){3}\d{1,3}$"
}

log_is_ip() {
    if [ $(is_ip "$1") ] ; then
        log "$LOG" "$(printf 'is_ip: %s\n' 'true')"
    else
        log "$LOG" "$(printf 'is_ip: %s\n' 'false')"
    fi
}

if [ $(is_ip "$CURR") ] ; then
    log "$LOG" "is_ip was true (with CURR='$CURR')"
    if  [ -n "$CURR" ] ; then
        log "$LOG" "CURR not empty"
        if [ "$LAST" != "$CURR" ] ; then
            log "$EXTERNAL_IP_LOG" "$CURR"
            echo "IP changed to: $CURR"
            echo -e "$CURR\n\nold was: $LAST" | mailx -s "New external IP" $EMAIL
        fi
    fi
else
    log "$LOG" "is_ip was false (with CURR='$CURR')"
fi
