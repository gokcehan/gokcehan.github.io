#!/usr/bin/env python
#
# coin.py
#
# Calculates the solution to the following problem:
#
# How many different ways can we make change of $1.00, given half-dollars,
# quarters, dimes, nickels, and pennies?  More generally, can we write a
# procedure to compute the number of ways to change any given amount of money?
#
# This problem is taken from the following book:
#
# Harold Abelson and Gerald Jay Sussman with Julie Sussman.
# Structure and Interpretation of Computer Programs (SICP), Second edition.
# The MIT Press, 1996.
# https://mitpress.mit.edu/sicp
#

coins = [1, 5, 10, 25, 50]

def count(amount):
    return count_iter(amount, len(coins))

def count_iter(amount, kinds):
    if amount == 0:
        return 1
    elif amount < 0 or kinds == 0:
        return 0
    else:
        c1 = count_iter(amount, kinds-1)
        c2 = count_iter(amount - coins[kinds-1], kinds)
        return c1 + c2

print(count(100))  # 292
print(count(500))  # 59576
# print(count(1000)) # RecursionError: maximum recursion depth exceeded in comparison

from functools import lru_cache

def count_memo(amount):
    return count_memo_iter(amount, len(coins))

@lru_cache(maxsize=None)
def count_memo_iter(amount, kinds):
    if amount == 0:
        return 1
    elif amount < 0 or kinds == 0:
        return 0
    else:
        c1 = count_memo_iter(amount, kinds-1)
        c2 = count_memo_iter(amount - coins[kinds-1], kinds)
        return c1 + c2

print(count_memo(100))  # 292
print(count_memo(500))  # 59576
# print(count_memo(1000)) # RecursionError: maximum recursion depth exceeded in comparison

def count_table(amount):
    table = [[0 for i in range(len(coins)+1)] for j in range(amount+1)]
    for i in range(len(coins)+1):
        table[0][i] = 1
    for i in range(1, len(coins)+1):
        for j in range(1, amount+1):
            c1 = table[j][i-1]
            c2 = table[j-coins[i-1]][i] if j >= coins[i-1] else 0
            table[j][i] = c1 + c2
    return table[amount][len(coins)]

print(count_table(100))  # 292
print(count_table(500))  # 59576
print(count_table(1000)) # 801451
