#!/bin/bash

source ~/bin/try-run.sh

while read repo ; do
    try_run "cd ~/$repo"
    git fetch --all
done < ~/.repos-to-fetch
