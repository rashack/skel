#!/bin/sh

head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | fold -w 16
