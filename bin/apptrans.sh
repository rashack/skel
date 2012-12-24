#!/bin/bash

DAY=$(date +%F)

# find if $1 or $2 is the destination host (ending with a ":")
if [[ $1 =~ .*: ]] ; then
    DEST_HOST=${1/%:/}
    DATA=$2
else
    DEST_HOST=${2/%:/}
    DATA=$1
fi

# determine the adm host (dradm1 or tdadm1)
case $DEST_HOST in
    drapp*)
	ADM_HOST=dradm1
	RTAR=/usr/sfw/bin/gtar
	;;
    tdaccapp*)
	ADM_HOST=dradm1
	RTAR=tar
	;;
    tdprodapp*)
	ADM_HOST=tdprodjump
	RTAR=tar
	;;
    tdapp*)
	ADM_HOST=tdadm1
	RTAR=/usr/sfw/bin/gtar
	;;
esac

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
ssh $ADM_HOST dd if=$ADM_FIFO | ssh $ADM_HOST ssh $DEST_HOST $RTAR -xf -

# remove fifos
rm $LOCAL_FIFO
ssh $ADM_HOST rm $ADM_FIFO
ssh $ADM_HOST ssh $DEST_HOST rm $DEST_FIFO
