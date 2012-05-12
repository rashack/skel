#!/bin/bash

DAY=$(date +%F)
DEST_HOST=$1
DATA=$2

if [[ $DEST_HOST =~ dr.*app ]] ; then
    ADM_HOST=dradm1
elif [[ $DEST_HOST =~ td.*app ]] ; then
    ADM_HOST=tdadm1
fi

if [ -z "$ADM_HOST" ] ; then
    echo "Could not determine ADM_HOST"
    exit 1
fi

LOCAL_FIFO=/tmp/FIFO-$DAY
ADM_FIFO=FIFO-$DAY
DEST_FIFO=FIFO-$DAY

# create fifos
mkfifo $LOCAL_FIFO
ssh $ADM_HOST mkfifo $ADM_FIFO
ssh $ADM_HOST ssh $DEST_HOST mkfifo $DEST_FIFO

# transfer data
tar -cO -C $(dirname $DATA) $(basename $DATA) | ssh $ADM_HOST dd of=$ADM_FIFO &
ssh $ADM_HOST dd if=$ADM_FIFO | ssh $ADM_HOST ssh $DEST_HOST /usr/sfw/bin/gtar -xf -

# remove fifos
rm $LOCAL_FIFO
ssh $ADM_HOST rm $ADM_FIFO
ssh $ADM_HOST ssh $DEST_HOST rm $DEST_FIFO
