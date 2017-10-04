#!/bin/bash

set -eu

sha256_fingerprint() {
    local host="$1"
    ssh-keygen -f ~/.ssh/known_hosts -F "$host" | tail -1 | awk '{print $3}' |
        base64 -d | sha256sum | awk '{print $1}' | xxd -r -p | base64
}

sha256_fingerprint "$1"
