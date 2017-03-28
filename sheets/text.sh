#!/bin/sh

## tr (1) - translate or delete characters

echo 'hello world' | tr -d 'l'
# heo word

echo 'hello world' | tr l x
# hexxo worxd

echo 'Hello World' | tr A-Z a-z
# hello world

# https://en.wikipedia.org/wiki/Caesar_cipher
echo 'hello world' | tr a-z x-za-x
# ebiil tloia

# https://en.wikipedia.org/wiki/ROT13
echo 'hello world' | tr a-z n-za-m
# uryyb jbeyq

echo 'hello world' | tr a-z n-za-m | tr a-z n-za-m
# hello world

## cut (1) - remove sections from each line of files

head /etc/passwd | cut -d':' -f1
# root
# daemon
# bin
# sys
# sync
# games
# man
# lp
# mail
# news

head /etc/passwd | cut -d':' -f1,7
# root:/bin/bash
# daemon:/usr/sbin/nologin
# bin:/usr/sbin/nologin
# sys:/usr/sbin/nologin
# sync:/bin/sync
# games:/usr/sbin/nologin
# man:/usr/sbin/nologin
# lp:/usr/sbin/nologin
# mail:/usr/sbin/nologin
# news:/usr/sbin/nologin

## column (1) - columnate lists

echo "permission #hlink owner group size month day hh:mm fname"; ls -l /bin | tail -n +2 | head
# permission #hlink owner group size month day hh:mm fname
# -rwxr-xr-x 1 root root 1037528 Jun 24 18:44 bash
# -rwxr-xr-x 1 root root   31288 May 20  2015 bunzip2
# -rwxr-xr-x 1 root root 1964536 Aug 19  2015 busybox
# -rwxr-xr-x 1 root root   31288 May 20  2015 bzcat
# lrwxrwxrwx 1 root root       6 Jul 19 14:14 bzcmp -> bzdiff
# -rwxr-xr-x 1 root root    2140 May 20  2015 bzdiff
# lrwxrwxrwx 1 root root       6 Jul 19 14:14 bzegrep -> bzgrep
# -rwxr-xr-x 1 root root    4877 May 20  2015 bzexe
# lrwxrwxrwx 1 root root       6 Jul 19 14:14 bzfgrep -> bzgrep
# -rwxr-xr-x 1 root root    3642 May 20  2015 bzgrep

(echo "permission #hlink owner group size month day hh:mm fname"; ls -l /bin | tail -n +2 | head) | column -t
# permission  #hlink  owner  group  size     month  day  hh:mm  fname
# -rwxr-xr-x  1       root   root   1037528  Jun    24   18:44  bash
# -rwxr-xr-x  1       root   root   31288    May    20   2015   bunzip2
# -rwxr-xr-x  1       root   root   1964536  Aug    19   2015   busybox
# -rwxr-xr-x  1       root   root   31288    May    20   2015   bzcat
# lrwxrwxrwx  1       root   root   6        Jul    19   14:14  bzcmp    ->  bzdiff
# -rwxr-xr-x  1       root   root   2140     May    20   2015   bzdiff
# lrwxrwxrwx  1       root   root   6        Jul    19   14:14  bzegrep  ->  bzgrep
# -rwxr-xr-x  1       root   root   4877     May    20   2015   bzexe
# lrwxrwxrwx  1       root   root   6        Jul    19   14:14  bzfgrep  ->  bzgrep
# -rwxr-xr-x  1       root   root   3642     May    20   2015   bzgrep

head /etc/passwd | column -t -s':'
# root    x  0  0      root    /root            /bin/bash
# daemon  x  1  1      daemon  /usr/sbin        /usr/sbin/nologin
# bin     x  2  2      bin     /bin             /usr/sbin/nologin
# sys     x  3  3      sys     /dev             /usr/sbin/nologin
# sync    x  4  65534  sync    /bin             /bin/sync
# games   x  5  60     games   /usr/games       /usr/sbin/nologin
# man     x  6  12     man     /var/cache/man   /usr/sbin/nologin
# lp      x  7  7      lp      /var/spool/lpd   /usr/sbin/nologin
# mail    x  8  8      mail    /var/mail        /usr/sbin/nologin
# news    x  9  9      news    /var/spool/news  /usr/sbin/nologin

## sort (1) - sort lines of text files

echo -e "aaa\ndd\ncccc\nb" | sort
# aaa
# b
# cccc
# dd

du -d1 /usr
# 370032  /usr/bin
# 292716  /usr/local
# 53736   /usr/include
# 5072780 /usr/share
# 15804   /usr/sbin
# 2674208 /usr/lib
# 20      /usr/locale
# 664     /usr/games
# 250832  /usr/src
# 8730796 /usr

du -d1 /usr | sort -n
# 20      /usr/locale
# 664     /usr/games
# 15804   /usr/sbin
# 53736   /usr/include
# 250832  /usr/src
# 292716  /usr/local
# 370032  /usr/bin
# 2674208 /usr/lib
# 5072780 /usr/share
# 8730796 /usr

du -d1 /usr -h
# 362M    /usr/bin
# 286M    /usr/local
# 53M     /usr/include
# 4.9G    /usr/share
# 16M     /usr/sbin
# 2.6G    /usr/lib
# 20K     /usr/locale
# 664K    /usr/games
# 245M    /usr/src
# 8.4G    /usr

du -d1 /usr -h | sort -h
# 20K     /usr/locale
# 664K    /usr/games
# 16M     /usr/sbin
# 53M     /usr/include
# 245M    /usr/src
# 286M    /usr/local
# 362M    /usr/bin
# 2.6G    /usr/lib
# 4.9G    /usr/share
# 8.4G    /usr

cat /etc/passwd | cut -d':' -f1,7 | column -t -s':' | sort -k2
# root               /bin/bash
# gokce              /bin/bash
# _apt               /bin/false
# avahi              /bin/false
# ..
# speech-dispatcher  /bin/false
# systemd-bus-proxy  /bin/false
# sync               /bin/sync
# lp                 /usr/sbin/nologin
# bin                /usr/sbin/nologin
# ..
# nobody             /usr/sbin/nologin
# www-data           /usr/sbin/nologin

## uniq (1) - report or omit repeated lines

cat /etc/passwd | cut -d':' -f7 | sort | uniq
# /bin/bash
# /bin/false
# /bin/sync
# /usr/sbin/nologin

cat /etc/passwd | cut -d':' -f7 | sort | uniq -c
#       2 /bin/bash
#      22 /bin/false
#       1 /bin/sync
#      16 /usr/sbin/nologin

cat /etc/passwd | cut -d':' -f7 | sort | uniq -c | sort -rn
#      22 /bin/false
#      16 /usr/sbin/nologin
#       2 /bin/bash
#       1 /bin/sync

## wc (1) - print newline, word, and byte counts for each file

cat /etc/passwd | wc -l
# 41

cat /etc/passwd | wc -w
# 70

cat /etc/passwd | wc -c
# 2286

cat /etc/passwd | wc
#      41      70    2286

## shuf (1) - generate random permutations

cat /usr/share/dict/words | shuf | head
# crabbed
# raceway
# scare's
# altercations
# multiple
# eerier
# doubling
# donned
# Browne
# caucussed

## fmt (1) - simple optimal text formatter

shuf /usr/share/dict/words | fmt | head
# Collins kindergärtner Soyuz Cinderella pricklier laxness Domesday
# Darryl's lighted departments delphiniums envisioned grapevine's
# Noel's Casablanca's eyrie's seeker's Brendan exhorted Septembers
# flea dyke burgers hashing laminating mattock servicewoman approving
# Basho's crusade omits filthy pare performance's peccadillo certainly
# retributions hinterland tresses displace moonlights exposed mellows
# careened syncopating spotter's divas Ruby's measurement's waterfowls
# curvatures Reunion moistening playback hooped Man equators cable's
# thumbing camerawoman's Tenochtitlan's somersault's pizazz's Nestle
# reformation Senior overshot enlivened impugns Kroc kickoffs rocketry

shuf /usr/share/dict/words | fmt -w 40 | head
# eyesore's cagy Shorthorn outrider's
# capaciousness flaunt's unbelief
# Gaul's unselfishness fetishist's
# Serbian's UNICEF's eventually
# impenetrability bodkin eclectic's
# researches smokeless geriatrics dowdily
# Roth misidentify Congregationalist
# trails saying disciplines Congreve
# mystery's offends Astrakhan tinseling
# dearness disengages glinted leprous

## colrm (1) - remove columns from a file

shuf /usr/share/dict/words | fmt | head | colrm 40
# simile trappers jawbone hurdle's sorori
# Mongolia's hallway's misquotation measu
# Harrington nomination's guessers risk s
# belie Charlemagne's upside's mines enve
# Dannie tightwad fruitfulness's sensuali
# scrapbook's asters dicta coexistence Lu
# squeaked expressionists undies dingy ja
# Baldwin Ricky librettos sac lobbyist pa
# meddler teachable silversmiths percolat
# broadsword's advisers multiplier robs m

shuf /usr/share/dict/words | fmt | head | colrm 20 40
# busting Ahab ligatuions mammoths etymologists
# crams logging's toddu's vacillation's VLF's
# Prius bitterly sheln's italic interstice Rickey's
# Shavian's cylindersfhound's hoarders psychokinesis
# Pb devil's mumbled enlightens pleasantries wicker
# timidity gelding amath portraiture's motion's
# blowers Bolshevist erring song's cash diameter
# juiciness bearded G obeisances mob's inkwell's wok
# paddocked jiffies Crneyron's Napster tidiness's
# need's aureola leg nnelling Mohawk craftsmanship's
