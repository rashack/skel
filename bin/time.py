#!/usr/bin/python

from sys import argv
import time

def time_diff(t1, t2):
    return time.mktime(t2) - time.mktime(t1)

#print argv.len
f = open(argv[1], 'r')
print f.readline()

t1 = time.strptime("2012-04-30_16:48:28", "%Y-%m-%d_%H:%M:%S")
t2 = time.strptime("2012-04-30_17:48:28", "%Y-%m-%d_%H:%M:%S")

print time_diff(t1, t2);
