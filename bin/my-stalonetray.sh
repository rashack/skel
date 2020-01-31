#!/bin/bash

set -euo pipefail

source ~/bin/dzen2-env

SIZE=16
X_POS=$(( $SCREEN_WIDTH - $SIZE ))

stalonetray --icon-size=$SIZE --geometry 1x1+$X_POS+0 --grow-gravity SE &
