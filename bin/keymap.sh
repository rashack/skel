#!/bin/bash

set -euo pipefail

setxkbmap -option -option ctrl:nocaps $1
kinesis-x-mod
