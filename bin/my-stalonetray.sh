#!/bin/bash

set -euo pipefail

source ~/bin/dzen2-env

SIZE=16
X_POS=$(( $SCREEN_WIDTH - $SIZE ))

ts=$(date +'%F %T')
echo "$ts starting stalonetray: exec stalonetray --icon-size=$SIZE --geometry 1x1+$X_POS+0 --grow-gravity SE" 2>&1 >> ~/.dzen2.log

exec stalonetray --icon-size=$SIZE --geometry 1x1+$X_POS+0 --grow-gravity SE 2>&1 >> ~/.dzen2.log
