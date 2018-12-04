#!/bin/bash

CURRENT=$(readlink /usr/local/firefox)
LATEST=$(ls -1tr ~/Downloads/firefox-*.tar* | tail -1)
LATEST_VER=$(basename $LATEST | sed 's/.*\(firefox-[0-9\.]\+\)\.tar\..*/\1/')

echo "CURRENT=$CURRENT"
echo "LATEST=$LATEST"
echo "LATEST_VER=$LATEST_VER"

cd /usr/local
if [ -d $LATEST_VER ] ; then
    echo "The latest available version is already in place."
    exit 1
fi
sudo rm firefox
sudo tar xf $LATEST
sudo mv firefox $LATEST_VER
sudo ln -s $LATEST_VER firefox
