#!/usr/bin/python2

from sys import argv
from datetime import date, datetime, timedelta
import time

class Day:
    def __init__(self, tss):
        self.tss = tss # [Ts]
        self.day_no = self.tss[0].ts.tm_wday
    def in_time(self):
        pass
    def __str__(self):
        return self.str(0, 0)
    def str(self, active_tot, length_tot):
        tsf = self.tss[0]
        tsl = last(self.tss)
        return "%02d %d %s [%s - %s] %s %s %s %s" % (
            week(tsf.ts), self.day_no, ts2datestr(tsf.ts),
            ts2timestr(tsf.ts), ts2timestr(tsl.ts), timedeltastring(self.length()),
            seconds2str(self.active()), seconds2str(active_tot),
            "% 3d:%02d:%02d" % secs2hms(timedeltasecs(length_tot)))
    def length(self):
        return daylength(self.tss[0].ts, last(self.tss).ts)
    def active(self):
        acc = 0
        if self.tss[0].out(): # add 00:00:00 IN if first in tss is OUT
            acc += Ts(day_start(self.tss[0].ts), 'IN').secs()
        if not last(self.tss).out(): # add now or end of day depending on "self.day" == today
            if datetime.now().timetuple()[0:3] == self.tss[0].ts[0:3]: # add now
                acc += Ts(datetime.now().timetuple(), 'OUT').secs()
            else:
                acc += Ts(day_end(self.tss[0].ts), 'OUT').secs() # add end of day
        # don't add consecutive IN's or OUT's
        prev_out = self.tss[0].out()
        acc += self.tss[0].secs()
        for ts in self.tss[1:]:
            if prev_out != ts.out():
                acc += ts.secs()
            prev_out = ts.out()
        return acc
    def year(self):
        return self.tss[0].ts.tm_year
    def week(self):
        return week(self.tss[0].ts)
    def day(self):
        return self.tss[0].ts.tm_wday

class Ts:
    def __init__(self, ts, out): # time.struct_time, string
        self.ts     = ts
        self.outstr = out
        self.date   = self.ts[0:3]
    def __str__(self):
        return "%s %s" % (ts2datestr(self.ts), ts2timestr(self.ts))
    def out(self):
        return self.outstr == "OUT"
    def secs(self):
        if self.out():
            return time.mktime(self.ts)
        else:
            return -time.mktime(self.ts)

# [string] -> Ts
def ts_from_line(line):
    ts = str2time(line[0])
    return Ts(ts, line[1])

def last(list):
    return list[len(list)-1]

# Return a time object parsed from a string formatted according to iso-8601(-ish).
# string -> time.struct_time
def str2time(str):
#          time.strptime("2013-08-25_20:25:26", "%Y-%m-%d_%H:%M:%S")
    return time.strptime(str, "%Y-%m-%d_%H:%M:%S")

# Day of month
# time.struct_time -> integer
def day(t0):
    return t0[2]

# iso-8601 week number
# time.struct_time -> integer
def week(t0):
    return int(date.fromtimestamp(time.mktime(t0)).strftime('%W')) + 1

# timedelta -> int
def timedeltasecs(td):
    return td.days * 3600 * 24 + td.seconds

# timedelta -> string
def timedeltastring(td):
    return seconds2str(timedeltasecs(td))

# Seconds to hours, minutes and seconds.
# integer -> (int, int, int)
def secs2hms(secs):
    hours, remainder = divmod(secs, 3600)
    minutes, seconds = divmod(remainder, 60)
    return (hours, minutes, seconds)

# integer -> string
def seconds2str(secs):
    """
    >>> seconds2str(130)
    '00:02:10'
    """
    return '%02d:%02d:%02d' % secs2hms(secs)

# First time of the day (YYYY-mm-DD HH:MM:SS -> YYYY-mm-DD 00:00:00)
# time.struct_time -> time.struct_time
def day_start(ts):
    return datetime(*ts[0:3]).timetuple()

# First time of the next day (YYYY-mm-DD HH:MM:SS -> YYYY-mm-(DD+1) 00:00:00)
# time.struct_time -> time.struct_time
def day_end(ts):
    return day_start((tt2dt(ts) + timedelta(days=1)).timetuple())

# time.struct_time -> string
def ts2datestr(timestruct):
    return date.fromtimestamp(time.mktime(timestruct)).strftime('%Y-%m-%d')

# time.struct_time -> string
def ts2timestr(ts):
    return datetime.fromtimestamp(time.mktime(ts)).strftime('%H:%M:%S')

# time.struct_time -> datetime.datetime
def tt2dt(tt):
    return datetime(*tt[0:6])

# time.struct_time, time.struct_time -> datetime.timedelta
def daylength(t0, t1):
    return tt2dt(t1) - tt2dt(t0)

# time.struct_time -> date
def ts2date(t0):
    return date(t0[0], t0[1], t0[2])

def print_header():
    #       'WW ? YYYY-MM-DD [HH:MM:SS - HH:MM:SS] HH:MM:SS HH:MM:SS HH:MM:SS HHH:MM:SS'
    print '\nWW D [  date  ] [  day start - end  ] [d len ] [active] [act  S] [week  S]'

def readline(fp):
    line = fp.readline()
    while line is None or line == "\n":
        line = fp.readline()
    return line.split()

# filel -> [Day]
def parse_to_days(fp):
    line       = readline(fp)
    days       = []
    timestamps = []
    curr_date  = ts_from_line(line).date
    while line:
        ts = ts_from_line(line)
        if ts.date != curr_date:
            curr_date = ts.date
            if timestamps != []:
                days.append(Day(timestamps))
                timestamps = []
        timestamps.append(ts)
        line = readline(fp)
    if timestamps != []:
        days.append(Day(timestamps))
    fp.close()
    return days

def partition_to_years(days):
    years = {}
    for day in days:
        year = years.get(day.year(), {})
        week = year.get(day.week(), {})
        week[day.day()] = day
        year[day.week()] = week
        years[day.year()] = year
    return years

def print_all(years):
    for year, weeks in years.iteritems():
        print "Year", year
        for week, days in weeks.iteritems():
            print_header()
            print_week(days)

def print_week(days):
    active_tot = 0
    length_tot = timedelta(0)
    for day in days:
        active_tot += days[day].active()
        length_tot += days[day].length()
        print days[day].str(active_tot, length_tot)

def main():
    fp = open(argv[1], 'r')
    days = parse_to_days(fp)
    years = partition_to_years(days)
    fp.close()
    print_all(years)

def tests():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    if argv[1] == "-t":
        tests()
    else:
        main()
