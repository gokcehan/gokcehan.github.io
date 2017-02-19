#!/usr/bin/env python
#
# leak.py
#
# A toy memory leak detector for ltrace
#
# This is a proof of concept work for detecting memory leaks from the output of
# ltrace. The idea is to simply trace malloc and free calls in an execution and
# report non-freed allocations in the end. Other allocation methods are not
# added to keep it simple.
#
# This can only detect the existence of leaks without showing the location of
# the allocations in the source code. Also, since this is a dynamic analysis
# method, absence of leaks does not necessarily mean the program is leak free
# for all execution paths. Therefore, this is not very useful in practice.
#
# To run the script, you need to redirect ltrace output from stderr to stdout,
# and then redirect regular output to null device, and pipe stdout to this
# script. An example for `ls` command is shown below:
#
#     ltrace ls 2>&1 >/dev/null | ./leak.py
#

import re
import sys

lines = filter(lambda l: 'malloc' in l or 'free' in l, sys.stdin)

print '\nThese are all the malloc and free calls in the execution'
for line in lines:
    print line,

mems = {}
for line in lines:
    toks = line.split()

    # malloc(size) = addr
    if 'malloc' in toks[0]:
        size = re.search(r'malloc\((.*)\)', toks[0]).group(1)
        addr = toks[2]
        mems[addr] = size

    # free(addr) = <void>
    elif 'free' in toks[0]:
        addr = re.search(r'free\((.*)\)', toks[0]).group(1)
        mems.pop(addr, None)

print '\nExecution ended with the following non-freed allocations'
for k, v in mems.iteritems():
    print 'leaked', v, 'bytes of memory at', k
