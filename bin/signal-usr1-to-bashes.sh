#/bin/bash

for pid in $(pgrep -f -- '-bash$' | awk '{print $1}') ; do kill -10 $pid ; done
