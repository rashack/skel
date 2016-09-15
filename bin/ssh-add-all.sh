#!/bin/bash

ADDED=($(ssh-add -l | awk '{print $3}'))

for added in ${ADDED[@]} ; do
    echo "Already added key: ${added}"
done

for key in ~/.ssh/*.pub ; do
    KEY=${key//.pub}
    if [ $(grep -v $KEY <(echo ${ADDED[*]})) ] ; then
        ssh-add $KEY
    fi
done
