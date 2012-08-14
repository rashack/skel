#!/bin/sh

# Sort stdin based on a regex e.g.:
# cat pcl-funcs | regexSort.sh "\/.\+-"

sed 's/\(.*\('"$1"'\).*\)/\2 \1/' | sort | cut -d ' ' -f 1 --complement
