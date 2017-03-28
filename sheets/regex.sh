#!/bin/sh
# see also `man grep` and `man 7 regex`

## concatenation

echo 'abc' | grep 'a'    # abc
echo 'abc' | grep 'aa'   #
echo 'abc' | grep 'ab'   # abc
echo 'abc' | grep 'ab.'  # abc

## brackets

echo 'abc' | grep 'a[bd]c'       # abc
echo 'abc' | grep 'a\[bd\]c'     #
echo 'a[bd]c' | grep 'a[bd]c'    #
echo 'a[bd]c' | grep 'a\[bd\]c'  # a[bd]c

## extended regular expressions

echo 'abc' | grep -E 'a[bd]c'       # abc
echo 'abc' | grep -E 'a\[bd\]c'     #
echo 'a[bd]c' | grep -E 'a[bd]c'    #
echo 'a[bd]c' | grep -E 'a\[bd\]c'  # a[bd]c

## ranges and bracket expressions

echo 'abc' | grep -E 'a[bcdef]c'      # abc
echo 'abc' | grep -E 'a[b-f]c'        # abc
echo 'abc' | grep -E 'a[[:alpha:]]c'  # abc
echo 'a1c' | grep -E 'a[12345]c'      # a1c
echo 'a1c' | grep -E 'a[1-5]c'        # a1c
echo 'a1c' | grep -E 'a[[:digit:]]c'  # a1c

## negative matching

echo 'abc' | grep -E 'a[^b]c'          #
echo 'abc' | grep -E 'a[^bcdef]c'      #
echo 'abc' | grep -E 'a[^b-f]c'        #
echo 'abc' | grep -E 'a[^[:alpha:]]c'  #

## anchoring

echo 'abc' | grep -E '^ab'  # abc
echo 'abc' | grep -E '^bc'  #
echo 'abc' | grep -E 'ab$'  #
echo 'abc' | grep -E 'bc$'  # abc

## special expressions

echo 'bc' | grep -E '\sb'                         #
echo ' bc' | grep -E '\sb'                        #  bc
echo ' C_function_4_testing ' | grep -E '\s\w\s'  #

## ? operator

echo 'abc' | grep -E 'abcd'    #
echo 'abc' | grep -E 'abcd?'   # abc
echo 'abcd' | grep -E 'abcd?'  # abcd

## * operator

echo 'abbbc' | grep -E 'abc'   #
echo 'abbbc' | grep -E 'ab*c'  # abbbc
echo 'ac' | grep -E 'ab*c'     # ac

## + operator

echo 'abbbc' | grep -E 'abc'   #
echo 'abbbc' | grep -E 'ab+c'  # abbbc
echo 'ac' | grep -E 'ab+c'     #

## braces

echo 'abbbc' | grep -E 'abc'       #
echo 'abbbc' | grep -E 'ab{1,2}c'  #
echo 'abbbc' | grep -E 'ab{1,5}c'  # abbbc

## alternation

echo 'abc' | grep -E 'abc|def'          # abc
echo 'def' | grep -E 'abc|def'          # def
echo 'abcggg' | grep -E '(abc|def)ggg'  # abcggg
echo 'defggg' | grep -E '(abc|def)ggg'  # defggg

## backreferences (not necessarily linear time)

echo 'abcabc' | grep -E '(abc|def)\1'  # abcabc
echo 'abcdef' | grep -E '(abc|def)\1'  #
echo 'defabc' | grep -E '(abc|def)\1'  #
echo 'defdef' | grep -E '(abc|def)\1'  # defdef

## catastrophic backtracking

# grep (1) implements basic regular expressions using a DFA engine
#
# perl (1) implements the more powerful Perl Compatible Regular Expressions
# (PCRE) using backtracking
#
# https://swtch.com/~rsc/regexp/regexp1.html
#
# run the following examples in grep and perl and compare their performances
echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' | grep -E            'a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' | perl -ne 'print if /a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/'
