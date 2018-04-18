#!/bin/bash

set -euo pipefail

name() {
    docker ps | grep $1 | awk '{print $2}'
}

created() {
    docker ps | grep $1 | awk '{print $4,$5,$6}'
}

status() {
    docker ps | grep $1 | awk '{print $7,$8,$9}'
}

ports() {
    #docker ps | grep $1 | awk '{print $10}'
    docker ps -f id=$1 --format "{{.Ports}}"
}

size() {
    docker ps -f id=$1 --format "{{.Size}}"
}

ip() {
    docker inspect $1 \
        | sed -n '/NetworkSettings/,$ p' \
        | perl -ne 'print if /"IPAddress":/' \
        | head -1 \
        | grep -Po "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
}

header() {
    docker ps --format "table $1" | head -1
}

# do_all not working
do_all() {
    local fields="{{.ID}}\t {{.Image}} \t{{.RunningFor}} \t{{.Status}} \t{{.Ports}} \t{{.Size}}"
    header "$fields"
    for cid in $(docker ps -q) ; do
        st=$(docker ps -f id=$cid --format "{{.ID}}\t {{.Image}} \t{{.RunningFor}} \t{{.Status}} \t{{.Ports}} \t{{.Size}}")
        echo -e "$$(echo $st | tr -d '\n')\t$(ip $cid)\n"
    done
}
# do_all | column -s $'t' -t


do_m() {
    local fields="{{.ID}} {{.Image}} {{.RunningFor}} {{.Status}} {{.Ports}} {{.Size}}"
    echo -e "$(header "$fields" | sed 's/CONTAINER ID/CONTAINER-ID/' | tr ' ' '\t' | tr -d '\n')\tIP"
    for cid in $(docker ps -q) ; do
        local name=$(name $cid)
        local created=$(created $cid)
        local status=$(status $cid)
        local ports=$(ports $cid)
        local ip=$(ip $cid)
        local size=$(size $cid)
        printf "$cid\t$name\t$created\t$status\t$ports\t$size\t$ip\n" \
               "$cid""$name""$created""$status""$ports""$size""$ip"
    done
}

do_m | column -ns $'\t' -t

