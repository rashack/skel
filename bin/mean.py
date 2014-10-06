#!/usr/bin/python2

import sys

def file_or_stdin():
    if len(sys.argv) > 1:
        return open(sys.argv[1], 'r')
    else:
        return sys.stdin

def read_nums(fp):
    res = []
    fp = file_or_stdin()
    line = fp.readline()
    while line:
        x = float(line)
        res.append(x)
        line = fp.readline()
    return res

def median(lst):
    n = len(lst)
    if n % 2 == 1:
        return nums[n/2]
    else:
        return (nums[n/2] + nums[(n+1)/2]) / 2

nums = read_nums(file_or_stdin())
nums.sort()
n_sum = sum(nums)
print "sum: %f, median: %f, mean: %f, min: %f, max: %f" % (
    n_sum, median(nums), n_sum/len(nums), nums[0], nums[len(nums)-1])
