#!/bin/bash

latest() {
    local latest=$(find ~/Downloads/ -maxdepth 1 -type d -name 0xDBE\* | sort | tail -1)
    $latest/bin/0xdbe.sh
}

latest
