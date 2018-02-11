#!/usr/bin/env python
#
# rsa.py
#
# Simple RSA cryptosystem implementation
#
# RSA is a common public key cryptosystem. Asymmetric property relies on the
# computational difficulty of factorization when a number is a product of two
# large prime numbers. Encryption and decryption is performed using modular
# exponentiation.
#
# Following numbers are computed during key generation:
#
#     n = pq where p and q are random large primes
#     t = lcm(p-1, q-1)
#     e is a random coprime of t
#     d is the modular inverse of e (mod t)
#
# With these numbers, following keys are provided:
#
#     (n, e) is the encryption key (public)
#     (n, d) is the decryption key (private)
#
# Using these keys, following operations are performed:
#
#     c = m^e (mod n) (encryption)
#     m = c^d (mod n) (decryption)
#
# Implementation given here is neither fast nor secure enough to be of any
# practical use besides educational purposes.

import math
import random

def is_prime(n):
    if n < 2:
        return False
    for i in xrange(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False
    return True

def gen_prime(a, b):
    r = random.randrange(a, b)
    while not is_prime(r):
        r = random.randrange(a, b)
    return r

def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

def lcm(a, b):
    return (a * b) / gcd(a, b)

def gen_coprime(n):
    r = random.randrange(2, n)
    while gcd(n, r) != 1:
        r = random.randrange(2, n)
    return r

def mod_inverse(a, b):
    r, r_old = a, b
    x, x_old = 1, 0
    while r:
        (q, r), r_old = divmod(r_old, r), r
        x, x_old = x_old - q * x, x
    return x_old % b

def number(s):
    return long(s.encode('hex'), 16)

def string(n):
    return hex(n).lstrip('0x').rstrip('L').decode('hex')

def encrypt(m, e, n):
    return pow(m, e, n)

def decrypt(c, d, n):
    return pow(c, d, n)

p = gen_prime(1e12, 1e13)
q = gen_prime(1e14, 1e15)
n = p * q
t = lcm(p-1, q-1)
e = gen_coprime(t)
d = mod_inverse(e, t)

print 'p', p
print 'q', q
print 'n', n
print 't', t
print 'e', e
print 'd', d

# size of message should be less than size of n
# or you may need to divide the message into blocks
message = "hello world"

print 'm', message
cipher = encrypt(number(message), e, n)
print 'c', cipher
message = string(decrypt(cipher, d, n))
print 'm', message
