#!/bin/bash

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(printf "%02d" $(($(date +"%e") - 1)))
HOUR={18,19,20,21,22,23}

SOURCE_HOST=tdapp10adm
TARGET_HOST=drapp13adm

YMD=$YEAR$MONTH$DAY

TDAPP_FIFO=out-fifo-$YMD
TDADM_FIFO=through-fifo-$YMD
LOCAL_FIFO=/tmp/through-fifo-$YMD
DRADM_FIFO=through-fifo-$YMD

# create fifos
ssh tdadm1 ssh $SOURCE_HOST mkfifo $TDAPP_FIFO
ssh tdadm1 mkfifo $TDADM_FIFO
mkfifo $LOCAL_FIFO
ssh dradm1 mkfifo $DRADM_FIFO

# transfer data
# source -> source fifo
ssh tdadm1 ssh $SOURCE_HOST /usr/sfw/bin/gtar -cf $TDAPP_FIFO \~hercules/data/tx_space/txbackup/$YEAR/$MONTH/$DAY/$HOUR &
# source fifo -> tdadm1 fifo
ssh tdadm1 ssh $SOURCE_HOST dd if=$TDAPP_FIFO | ssh tdadm1 dd of=$TDADM_FIFO &
# tdadm1 fifo ->  localhost fifo
ssh tdadm1 dd if=$TDADM_FIFO | dd of=$LOCAL_FIFO &
# localhost fifo -> dradm1 fifo
dd if=$LOCAL_FIFO | ssh dradm1 dd of=$DRADM_FIFO &
# dradm1 fifo -> destination
ssh dradm1 dd if=$DRADM_FIFO | ssh dradm1 ssh $TARGET_HOST /usr/sfw/bin/gtar -xf -

# remove fifos
ssh tdadm1 ssh $SOURCE_HOST rm $TDAPP_FIFO
ssh tdadm1 rm $TDADM_FIFO
rm $LOCAL_FIFO
ssh dradm1 rm $DRADM_FIFO
