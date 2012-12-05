#!/usr/bin/python

import os

rows, columns = os.popen('stty size', 'r').read().split()

tens = ""
ones = ""
for x in range(0, int(columns)):
    ones += str(x % 10)
    if x % 10 != 0:
        tens += " "
    else:
        tens += str((x / 10) % 10)

print tens
print ones
