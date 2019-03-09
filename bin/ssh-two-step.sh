#!/bin/bash

set -eu

usage() {
    echo "usage: $0 HOST1 HOST2"
    echo
    echo "        Opens a port on HOST2 via HOST1 to localhost:22"
    echo
}

if [ $# != 2 ] ; then
    usage
    exit 2
fi

LOCAL_PORT=22

HOST1=$1
HOST1_PORT=2233

HOST2=$2
HOST2_PORT=2234

echo "Opening port $HOST2_PORT on $HOST2 via port $HOST1_PORT on $HOST1"
set -x
ssh -t -R $HOST1_PORT:localhost:$LOCAL_PORT $HOST1  \
    "ssh -R $HOST2_PORT:localhost:$HOST1_PORT $HOST2"
