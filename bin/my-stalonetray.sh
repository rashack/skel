#!/bin/bash

case `hostname` in
    chimp)    stalonetray --icon-size=16 --geometry 1x1+2544+0 --grow-gravity SE & ;;
    tp)       stalonetray --icon-size=16 --geometry 1x1+1264+0 --grow-gravity SE & ;;
    bluetang) stalonetray --icon-size=16 --geometry 1x1+1424+0 --grow-gravity SE & ;;
    tubarao)  stalonetray --icon-size=16 --geometry 1x1+2544+0 --grow-gravity SE & ;;
esac
