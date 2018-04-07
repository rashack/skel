#!/bin/bash

set -euo pipefail

dt() {
    local T0=$1
    local T1=$2
    echo "$T1 - $T0" | bc -l
}

img_to_text() {
    local f=$1
    dir=$(dirname $f)
    base=$(basename $f)
    name=$(echo $base | rev | cut -f 2- -d '.' | rev)
    suff=$(echo $base | rev | cut -f 1 -d '.' | rev)

    local rotated_name=$name-rotated
    echo "Maybe rotating $f to $rotated_name.$suff"
    local T0=$(date +%s.%N)
    exiftran -ao $rotated_name.$suff $f
    local T1=$(date +%s.%N)

    # textcleaner taken from
    # http://www.fmwconcepts.com/imagemagick/textcleaner/index.php
    local cleaned_name=$rotated_name-cleaned.ppm
    echo "Cleaning $rotated_name.$suff to $cleaned_name"
    local T2=$(date +%s.%N)
    textcleaner -g -e stretch -f 25 -o 10 -u -s 1 -T -p 10 \
                  $rotated_name.$suff $cleaned_name
    local T3=$(date +%s.%N)
    rm $rotated_name.$suff

    echo "Converting $cleaned_name to $name.txt"
    local T4=$(date +%s.%N)
    tesseract $cleaned_name $name -psm 6
    local T5=$(date +%s.%N)
    rm $cleaned_name

    echo "Time total=$(dt $T0 $T5) rotate=$(dt $T0 $T1) cleaning=$(dt $T2 $T3) ocr=$(dt $T4 $T5)"
}

img_to_text "$1"
