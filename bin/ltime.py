#!/usr/bin/python2

from collections import namedtuple
from sys import argv
from datetime import date, datetime, timedelta
import time

Interval = namedtuple('Interval', ['start', 'end', 'in_time'])


def time_diff (t0, t1):
    return time.mktime(t1) - time.mktime(t0)

# Return a time object parsed from a string formatted according to iso 8601-ish.
def str2time (str):
#          time.strptime ("2013-08-25_20:25:26", "%Y-%m-%d_%H:%M:%S")
    return time.strptime (str, "%Y-%m-%d_%H:%M:%S")

def day (t0):
    return t0[2]

def timediffstr (t0, t1):
    return tt2dt (t1) - tt2dt (t0)

# timedelta -> string
def timedeltastring (td):
    hours, remainder = divmod (td.seconds, 3600)
    minutes, seconds = divmod (remainder, 60)
    return '%02d:%02d:%02d' % (hours, minutes, seconds)

# timestruct -> date
def ts2datestr (timestruct):
    return date.fromtimestamp (time.mktime (timestruct)).strftime ('%Y-%m-%d')

# timestruct -> string
def ts2timestr (ts):
    return datetime.fromtimestamp (time.mktime (ts)).strftime ('%H:%M:%S')

# timestruct -> string
def daytimes (ts0, ts1):
    return '[' + ts2timestr (ts0) + ' - ' + ts2timestr (ts1) + ']'

# timetuple -> datetime
def tt2dt (tt):
    return datetime (*tt[0:6])

def daylength (t0, t1):
    return tt2dt (t1) - tt2dt (t0)

def print_day_sum (t0, daytime, daystart, dayend, weektot):
    thedate = ts2datestr (t0)
    totaltime = timedeltastring (timedelta (seconds=daytime))
    dl = timedeltastring (daylength (daystart, dayend))
    week_hrs = '%4.1f' % (weektot/3600)
    if t0.tm_wday == 0:
        #       'YYYY-MM-DD HH:MM:SS [HH:MM:SS - HH:MM:SS] HH:MM:SS H.M'
        print '\n[  date  ] [active] [  day start - end  ] [d len ] [total week time]'
    print thedate, totaltime, daytimes (daystart, dayend), dl, week_hrs

def parse_timestamp_file (filename):
    f = open(filename, 'r')
    line = f.readline ().split ()
    if line[1] == 'OUT': # If the first line of the file is an OUT, ignore it.
        line = f.readline ().split ()
    prev = None
    daytime = 0
    weektime = 0
    daystart = str2time (line[0])
    res = []
    while line:
        if prev is not None:
            t0 = str2time (prev[0])
            if len (line) == 2:
                t1 = str2time (line[0])
            else:
                t1 = time.localtime ()
                print t1[2]
            if day (t0) != day (t1): # new day
                weektime += daytime
                if line[1] == 'OUT': # stayed logged in past midnight
                    daytime += time_diff (t0, (date (t0[0], t0[1],
                                                     t0[2]) + timedelta (days=1)).timetuple ())
                    dayend = date (t1[0], t1[1], t1[2]).timetuple ()
                    print_day_sum (t0, daytime, daystart, dayend, weektime + daytime)
                    # since logged in past midnight, start at OUT time instead of 0
                    daytime = time_diff (date (t1[0], t1[1], t1[2]).timetuple (), t1)
                    daystart = date (t1[0], t1[1], t1[2]).timetuple ()
                else:
                    dayend = t0
                    res.append ((t0, daytime, daystart, dayend, weektime))
                    daytime = 0
                    daystart = t1
                if t0.tm_wday > t1.tm_wday or t0.tm_wday == 0: # new week
                    weektime = 0
            elif prev[1] == 'IN':
                daytime += time_diff (t0, t1)
        prev = line
        line = f.readline ().split ()
    if prev[1] == 'IN': # still logged in it seems, use present time
        daytime += time_diff (t1, time.localtime ())
        t1 = time.localtime ()
    res.append((t0, daytime, daystart, t1, weektime + daytime))
    return res

for day in parse_timestamp_file (argv[1]):
    print_day_sum (*day)
