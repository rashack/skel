#!/bin/bash

sqlplus -S admin/admin@adminadm @/home/kjean/ora-datetomsec.sql "$@"
