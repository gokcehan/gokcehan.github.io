#!/bin/sh
# see also `man grep` and `man 7 regex`

grep 'x' /usr/share/dict/words
# Acrux
# Acrux's
# Ajax
# ...
# xylophonist
# xylophonist's
# xylophonists

grep 'xy' /usr/share/dict/words
# Oxycontin
# Oxycontin's
# Roxy
# ...
# xylophonist
# xylophonist's
# xylophonists

grep 'xy\|yz' /usr/share/dict/words
# Byzantine
# Byzantine's
# Byzantines
# ...
# xylophonist
# xylophonist's
# xylophonists

grep -E 'xy|yz' /usr/share/dict/words
# Byzantine
# Byzantine's
# Byzantines
# ...
# xylophonist
# xylophonist's
# xylophonists

grep -E '(xy|yz)a' /usr/share/dict/words
# Byzantine
# Byzantine's
# Byzantines
# Byzantium
# Byzantium's
# oxyacetylene
# oxyacetylene's

grep -E '[aeiou]xy' /usr/share/dict/words
# Roxy
# Roxy's
# apoplexy
# ...
# sexy
# taxying
# waxy

grep -E '[aeiou]xy.s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# pixy's
# proxy's

grep -E '[aeiou]xy.?s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# paroxysm
# paroxysm's
# paroxysms
# pixy's
# proxy's

grep -E '[aeiou]xy.*s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# oxyacetylene's
# oxygen's
# oxygenates
# oxygenation's
# oxymoron's
# oxymorons
# paroxysm
# paroxysm's
# paroxysms
# pixy's
# proxy's

grep -E '[aeiou]xy.+s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# oxyacetylene's
# oxygen's
# oxygenates
# oxygenation's
# oxymoron's
# oxymorons
# paroxysm's
# paroxysms
# pixy's
# proxy's

grep -E '[aeiou]xy.{2}s' /usr/share/dict/words
# paroxysms

grep -E '[aeiou]xy.{2,}s' /usr/share/dict/words
# oxyacetylene's
# oxygen's
# oxygenates
# oxygenation's
# oxymoron's
# oxymorons
# paroxysm's
# paroxysms

grep -E '[aeiou]xy.{,3}s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# paroxysm
# paroxysm's
# paroxysms
# pixy's
# proxy's

grep -E '[aeiou]xy.{1,3}s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# paroxysm's
# paroxysms
# pixy's
# proxy's

grep -E "[aeiou]xy.*[.,']s" /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# oxyacetylene's
# oxygen's
# oxygenation's
# oxymoron's
# paroxysm's
# pixy's
# proxy's

grep -E '[aeiou]xy.*[[:punct:]]s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# oxyacetylene's
# oxygen's
# oxygenation's
# oxymoron's
# paroxysm's
# pixy's
# proxy's

grep -E '[aeiou]xy.*[^[:punct:]]s' /usr/share/dict/words
# oxygenates
# oxymorons
# paroxysms

grep -E '[aeiou]xy.*[abcdefghijklmn]s' /usr/share/dict/words
# oxygenates
# oxymorons
# paroxysms

grep -E '[aeiou]xy.*[a-n]s' /usr/share/dict/words
# oxygenates
# oxymorons
# paroxysms

grep -E '[aeiou]xy.*[^a-n]s' /usr/share/dict/words
# Roxy's
# apoplexy's
# epoxy's
# galaxy's
# heterodoxy's
# orthodoxy's
# oxyacetylene's
# oxygen's
# oxygenation's
# oxymoron's
# paroxysm's
# pixy's
# proxy's

grep -E '^[aeiou]xy' /usr/share/dict/words
# oxyacetylene
# oxyacetylene's
# oxygen
# oxygen's
# oxygenate
# oxygenated
# oxygenates
# oxygenating
# oxygenation
# oxygenation's
# oxymora
# oxymoron
# oxymoron's
# oxymorons

grep -E '[aeiou]xy$' /usr/share/dict/words
# Roxy
# apoplexy
# epoxy
# foxy
# galaxy
# heterodoxy
# orthodoxy
# pixy
# proxy
# sexy
# waxy

grep -E '^[aeiou].*xy$' /usr/share/dict/words
# apoplexy
# epoxy
# orthodoxy

## special escapes (not POSIX standard)

printf 'hello world' | grep -E 'o[[:space:]]w'
# hello world

printf 'hello world' | grep -E 'o\sw'
# hello world

printf 'hello world' | grep -E 'e[^[:space:]]*o'
# hello world

printf 'hello world' | grep -E 'e\S*o'
# hello world

printf 'one two three' | grep -E '\<two\>'
# one two three

printf 'one two three' | grep -E '\<wo'
# (does not match)

printf 'one two three' | grep -E '\bwo'
# (does not match)

printf 'one two three' | grep -E 'wo'
# one two three

printf 'one two three' | grep -E 'tw\>'
# (does not match)

printf 'one two three' | grep -E 'tw\b'
# (does not match)

printf 'one two three' | grep -E 'tw'
# one two three

printf 'C_Function_4_Demonstration()' | grep -E '\s*[_[:alnum:]]*\(\s*\)'
# C_Function_4_Demonstration()

printf 'C_Function_4_Demonstration()' | grep -E '\s*\w*\(\s*\)'
# C_Function_4_Demonstration()

## backreferences (not necessarily runs in linear time)

grep -E '([a-f][aeiou][a-f]).*\1' /usr/share/dict/words
# Deadhead
# Deadhead's
# deficiencies
# inefficiencies

## extra (catastrophic backtracking)

# grep (1) implements basic regular expressions using a Thompson NFA engine
# 
# perl (1) implements the more powerful Perl Compatible Regular Expressions
# (PCRE) using backtracking
# 
# https://swtch.com/~rsc/regexp/regexp1.html
# 
# run the following examples in grep and perl and compare their performances
echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' | grep -E            'a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' | perl -ne 'print if /a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/'
