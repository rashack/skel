#!/usr/bin/env bash

set -euo pipefail

if [[ "$1" == "--lib" ]] ; then
    lib="--lib"
    shift
else
    lib=""
fi

cargo new $lib $1
cd $1
cargo build
if [ -z $lib ] ; then
    sed -i -e '/edition = "2021"/a\'$'\n'"default-run = \"$1\""$'\n' Cargo.toml
fi
git add .
git commit -m "New project from 'cargo run'"

echo "*~" >> .gitignore
git commit -m "Ignore backup files" .gitignore

echo -e "# ~/.rsync-filter\n- target\n" > .rsync-filter
git add .rsync-filter
git commit -m "Add .rsync-filter to prevent sync/backup of target directory"

echo 'edition = "2021"' > rustfmt.toml
git add rustfmt.toml
git commit -m "Add rustfmt.toml to convince rust analyzer main can be async"
