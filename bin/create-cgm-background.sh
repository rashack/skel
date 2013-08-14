#!/bin/bash

BACKG=~/src/cgm/wallpaper-1920x1080.png
TEXTF=~/src/cgm/commands
TEXTI=~/src/cgm/text-background.png
RES=~/src/cgm/background.png

convert -size 1920x1080 \
    -background none -pointsize 12 -fill white \
    -gravity northwest label:@$TEXTF \
    -trim -bordercolor none -border 32 \
    $TEXTI

composite $TEXTI $BACKG -gravity northeast $RES
