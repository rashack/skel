#!/bin/bash

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(printf "%02d" $(($(date +"%d") - 1)))
HOUR=20

YMD=$YEAR$MONTH$DAY

TDAPP_FIFO=out-fifo-$YMD
TDADM_FIFO=through-fifo-$YMD
LOCAL_FIFO=/tmp/through-fifo-$YMD
DRADM_FIFO=through-fifo-$YMD

# create fifos
ssh tdadm1 ssh tdapp10adm mkfifo $TDAPP_FIFO
ssh tdadm1 mkfifo $TDADM_FIFO
mkfifo $LOCAL_FIFO
ssh dradm1 mkfifo $DRADM_FIFO

# transfer data
ssh tdadm1 ssh tdapp10adm /usr/sfw/bin/gtar -cf $TDAPP_FIFO ../hercules/data/tx_space/txbackup/$YEAR/$MONTH/$DAY/$HOUR &
ssh tdadm1 ssh tdapp10adm dd if=$TDAPP_FIFO | ssh tdadm1 dd of=$TDADM_FIFO &
ssh tdadm1 dd if=$TDADM_FIFO | dd of=$LOCAL_FIFO &
dd if=$LOCAL_FIFO | ssh dradm1 dd of=$DRADM_FIFO &
ssh dradm1 dd if=$DRADM_FIFO | ssh dradm1 ssh drapp17adm /usr/sfw/bin/gtar -xf -

# remove fifos
ssh tdadm1 ssh tdapp10adm rm $TDAPP_FIFO
ssh tdadm1 rm $TDADM_FIFO
rm $LOCAL_FIFO
ssh dradm1 rm $DRADM_FIFO
