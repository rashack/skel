#!/usr/bin/python

from sys import argv
from datetime import date, datetime, timedelta
import time


def time_diff (t0, t1):
    return time.mktime(t1) - time.mktime(t0)

# Return a time object parsed from a string formatted according to iso 8601-ish.
def str2time (str):
#          time.strptime ("2013-08-25_20:25:26", "%Y-%m-%d_%H:%M:%S")
    return time.strptime (str, "%Y-%m-%d_%H:%M:%S")

def day (t0):
    return t0[2]

def timediffstr (t0, t1):
    return datetime (*t1[0:6]) - datetime (*t0[0:6])

def print_day_sum (t0, daytime):
    thedate = date.fromtimestamp (time.mktime (t0))
    print thedate.strftime ('%Y-%m-%d'), timedelta (seconds=daytime)

f = open(argv[1], 'r')
line = f.readline ().split ()
if line[1] == 'OUT': # If the first line of the file is an OUT, ignore it.
    line = f.readline ().split ()
prev = None
daytime = 0
while line:
    if prev is not None:
        t0 = str2time (prev[0])
        if len (line) == 2:
            t1 = str2time (line[0])
        else:
            t1 = time.localtime ()
            print t1[2]
        if day (t0) != day (t1):
            if line[1] == 'OUT':
                daytime += time_diff (t0, (date (t0[0], t0[1],
                                                 t0[2]) + timedelta (days=1)).timetuple ())
                print_day_sum (t0, daytime)
                # if logged in over midnight start at OUT time instead of 0
                daytime = time_diff (date (t1[0], t1[1], t1[2]).timetuple (), t1)
            else:
                print_day_sum (t0, daytime)
                daytime = 0
        elif prev[1] == 'IN':
            daytime += time_diff (t0, t1)
    prev = line
    line = f.readline ().split ()
if prev[1] == 'IN':
    daytime += time_diff (t1, time.localtime ())
print_day_sum (t0, daytime)
