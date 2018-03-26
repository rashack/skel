#!/bin/bash

set -euo pipefail

SCREEN_WIDTH=$(xdpyinfo | grep 'dimensions:' | awk '{print $2}' | cut -d x -f 1)
SIZE=16
X_POS=$(( $SCREEN_WIDTH - $SIZE ))

stalonetray --icon-size=$SIZE --geometry 1x1+$X_POS+0 --grow-gravity SE &
