#!/bin/sh
# see also `man awk`

awk '{ print }' /etc/passwd | head
# root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# bin:x:2:2:bin:/bin:/usr/sbin/nologin
# sys:x:3:3:sys:/dev:/usr/sbin/nologin
# sync:x:4:65534:sync:/bin:/bin/sync
# games:x:5:60:games:/usr/games:/usr/sbin/nologin
# man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
# lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
# mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
# news:x:9:9:news:/var/spool/news:/usr/sbin/nologin

awk '{ print $0 }' /etc/passwd | head
# root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# bin:x:2:2:bin:/bin:/usr/sbin/nologin
# sys:x:3:3:sys:/dev:/usr/sbin/nologin
# sync:x:4:65534:sync:/bin:/bin/sync
# games:x:5:60:games:/usr/games:/usr/sbin/nologin
# man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
# lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
# mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
# news:x:9:9:news:/var/spool/news:/usr/sbin/nologin

head /etc/passwd | awk '{ print $0 }'
# root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# bin:x:2:2:bin:/bin:/usr/sbin/nologin
# sys:x:3:3:sys:/dev:/usr/sbin/nologin
# sync:x:4:65534:sync:/bin:/bin/sync
# games:x:5:60:games:/usr/games:/usr/sbin/nologin
# man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
# lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
# mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
# news:x:9:9:news:/var/spool/news:/usr/sbin/nologin

head /etc/passwd | awk '{ print $1 }'
# root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# bin:x:2:2:bin:/bin:/usr/sbin/nologin
# sys:x:3:3:sys:/dev:/usr/sbin/nologin
# sync:x:4:65534:sync:/bin:/bin/sync
# games:x:5:60:games:/usr/games:/usr/sbin/nologin
# man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
# lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
# mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
# news:x:9:9:news:/var/spool/news:/usr/sbin/nologin

head /etc/passwd | awk -F: '{ print $1 }'
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

head /etc/passwd | awk -F: '{ printf "%-20s%s\n", $1, $7 }'
# root                /bin/bash
# daemon              /usr/sbin/nologin
# bin                 /usr/sbin/nologin
# sys                 /usr/sbin/nologin
# sync                /bin/sync
# games               /usr/sbin/nologin
# man                 /usr/sbin/nologin
# lp                  /usr/sbin/nologin
# mail                /usr/sbin/nologin
# news                /usr/sbin/nologin

head /etc/passwd | awk 'BEGIN { FS=":" } { print $1 }'
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

awk 'BEGIN { print ARGC }' /etc/passwd
# 2

awk 'BEGIN { for (i = 0; i < ARGC; i++) print ARGV[i] }' /etc/passwd
# awk
# /etc/passwd

awk '
BEGIN {
    for (i = 0; i < ARGC; i++) {
        print ARGV[i]
    }
}' /etc/passwd
# awk
# /etc/passwd

awk 'BEGIN { print ENVIRON["HOME"] }'
# /home/gokce

head /etc/passwd | awk -F: '{ printf "%d - %d\n", NR, NF }'
# 1 - 7
# 2 - 7
# 3 - 7
# 4 - 7
# 5 - 7
# 6 - 7
# 7 - 7
# 8 - 7
# 9 - 7
# 10 - 7

cat /etc/passwd | awk -F: '/bash/'
# root:x:0:0:root:/root:/bin/bash
# gokce:x:1000:1000:gokce,,,:/home/gokce:/bin/bash

cat /etc/passwd | awk -F: '/bash/ { print $0 }'
# root:x:0:0:root:/root:/bin/bash
# gokce:x:1000:1000:gokce,,,:/home/gokce:/bin/bash

cat /etc/passwd | awk -F: '/bash/ { print $1 }'
# root
# gokce

cat /etc/passwd | awk -F: '$7 == "/bin/bash" { print $1 }'
# root
# gokce

cat /etc/passwd | awk -F: 'NR == 1, NR == 5 { print $1 }'
# root
# daemon
# bin
# sys
# sync

cat /etc/passwd | awk '
{ numlines++ }
END { print numlines }'
# 41

cat /etc/passwd | awk -F: '
{ shell[$7]++ }
END { for (i in shell) printf "%-20s%d\n", i, shell[i] }'
# /bin/sync           1
# /bin/bash           2
# /bin/false          22
# /usr/sbin/nologin   16

awk 'BEGIN {
    "date" | getline line
    print line
    close("date")
}'
# Thu Oct 13 21:04:58 EEST 2016

awk 'BEGIN {
    cmd = "date -u"
    cmd | getline line
    print line
    close(cmd)
}'
# Thu Oct 13 18:05:03 UTC 2016

awk 'BEGIN {
    print "hello world" | "cat"
    close("cat")
}'
# hello world

awk 'BEGIN {
    print "ls -l /bin/echo" | "sh"
    close("sh")
}'
# -rwxr-xr-x 1 root root 31376 Feb 18  2016 /bin/echo

awk 'BEGIN { system("ls -l /bin/echo") }'
# -rwxr-xr-x 1 root root 31376 Feb 18  2016 /bin/echo

awk '
BEGIN {
    print fact(5)
}

function fact(n) {
    if (n < 2)
        return 1;
    return n * fact(n-1);
}'
# 120

# mean
seq 100 | shuf | head | awk '
{ sum += $0 } 
END { print sum / NR }'
# 72.7

# escape '$' characters inside double quotes for aliasing
alias mean="awk '{ sum += \$0 } END { print sum / NR }'"

seq 100 | shuf | head | mean
# 49.2

# stdev
seq 100 | shuf | head | awk '
{ sum += $0; sqs += $0^2 }
END { print sqrt(NR * sqs - sum^2) / NR }'
# 29.3966

# escape '$' characters inside double quotes for aliasing
alias stdev="awk '{ sum += \$0; sqs += \$0^2 } END { print sqrt(NR * sqs - sum^2) / NR }'"

seq 100 | shuf | head | stdev
# 27.7027

# from 20 random words generate a text with 100 random words
shuf /usr/share/dict/words | head -20 | shuf -r | head -100 | fmt
# updating poignantly poignantly lobotomies Intel's seesaw's baas vise's
# hurray's Intel's Grampians Grampians settlement whooshing intertwines
# Terrell lobotomies baas tiny Turing hurray's lobotomies hurray's idea's
# underwriter's Grampians seesaw's Turing Intel's whooshing vise's idea's
# Terrell baas underwriter's whooshing Turing Gorbachev freshets pluckier
# settlement lobotomies baas Terrell settlement pluckier freshets pluckier
# underwriter's Terrell baas lobotomies pluckier poignantly intertwines
# tiny idea's settlement pluckier tiny Terrell baas settlement pluckier
# idea's freshets vise's updating Grampians underwriter's settlement
# intertwines hurray's poignantly vise's underwriter's updating baas idea's
# intertwines Turing underwriter's underwriter's Grampians vise's baas
# Terrell Terrell poignantly Grampians hurray's seesaw's pluckier Turing
# lobotomies poignantly Terrell freshets underwriter's tiny

# word frequency (adapted from 'Effective awk Programming' by 'Arnold Robbins')
shuf /usr/share/dict/words | head -20 | shuf -r | head -100 | fmt | awk '
{
    $0 = tolower($0)
    gsub(/[^[:alnum:]_[:blank:]]/, "", $0)
    for (i = 1; i <= NF; i++) {
        freq[$i]++
        if (maxlen < length($i)) {
            maxlen = length($i)
        }
    }
}

END {
    sort = "sort -k2 -rn | head -n 5"
    for (word in freq) {
        printf "%-*s%d\n", maxlen, word, freq[word] | sort
    }
    close(sort)
}'
# walmarts    11
# hogs        7
# trousseaux  6
# trees       6
# priming     6
