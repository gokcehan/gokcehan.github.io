#!/bin/sh
# see also `man sh` and `man bash`
# see wiki.ubuntu.com/DashAsBinSh for bash specific features
# see mywiki.wooledge.org/BashPitfalls for common pitfalls

## tilde expansion

echo ~      # /home/gokce
echo ~foo   # ~foo
echo ~/foo  # /home/gokce/foo
echo foo~   # foo~
echo foo/~  # foo/~
echo '~'    # ~
echo "~"    # ~

## parameter expansion

foo="hello"

echo $foo       # hello
echo $foobar    # (prints nothing since there is no $foobar)
echo ${foo}bar  # hellobar
echo '$foo'     # $foo
echo "$foo"     # hello

## command substitution

which ls       # /bin/ls
ls -l /bin/ls  # -rwxr-xr-x 1 root root 126584 Feb 18  2016 /bin/ls

echo `which ls`            # /bin/ls
echo `ls -l \`which ls\``  # -rwxr-xr-x 1 root root 126584 Feb 18 2016 /bin/ls
echo $(which ls)           # /bin/ls
echo $(ls -l $(which ls))  # -rwxr-xr-x 1 root root 126584 Feb 18 2016 /bin/ls

## arithmetic expansion

echo 2+2                   # 2+2
echo $((2+2))              # 4
echo $((4/2))              # 2
echo $((5/2))              # 2
echo '5/2' | bc            # 2
echo 'scale=10; 5/2' | bc  # 2.5000000000
echo '5/2' | bc -l         # 2.50000000000000000000

## path expansion

echo *    # foo foo.c bar bar.c ..
echo *.c  # foo.c bar.c ..
echo '*'  # *
echo "*"  # *

## brace expansion (bash)

echo foo.{c,h}  # foo.c foo.h
echo foo{.c,}   # foo.c foo

## conditionals (0 means true, non-0 means false)

# you can put this in your ~/.bashrc to display error codes
EC() { echo -e '\e[1;33m'code $?'\e[m\n'; }
trap EC ERR

type -a true
# true is a shell builtin
# true is /bin/true

type -a false
# false is a shell builtin
# false is /bin/false

true;  echo $?                              # 0
false; echo $?                              # 1
true  && echo 'is true'                     # is true
false && echo 'is false'                    #
true  && echo 'is true' || echo 'is false'  # is true
false && echo 'is true' || echo 'is false'  # is false

## test (1) - check file types and compare values

type -a test
# test is a shell builtin
# test is /usr/bin/test

test -e /bin; echo $?                        # 0
test -e /bin/ls; echo $?                     # 0
test -f /bin; echo $?                        # 1
test -f /bin/ls; echo $?                     # 0
test -f /path/to/non/existent/file; echo $?  # 1
test -d /bin; echo $?                        # 0
test -d /bin/ls; echo $?                     # 1
test -d /path/to/non/existent/dir; echo $?   # 1
test -r /bin/ls; echo $?                     # 0
test -w /bin/ls; echo $?                     # 1
test -r /bin/ls -a -w /bin/ls; echo $?       # 1
test -r /bin/ls -o -w /bin/ls; echo $?       # 0
test ! -r /bin/ls; echo $?                   # 1
test -n $HOSTNAME; echo $?                   # 0
test -z $HOSTNAME; echo $?                   # 1
test $(uname -s) = "Linux"; echo $?          # 0
test $(uname -m) != "x86_64"; echo $?        # 1

## [ (1) - check file types and compare values

type -a '['
# [ is a shell builtin
# [ is /usr/bin/[

[ -e /bin/ls ]; echo $?             # 0
[ -e /bin/asd ]; echo $?            # 1
[-e /bin/ls ]; echo $?              # /bin/bash: [-e: command not found
[ -e /bin/ls]; echo $?              # /bin/bash: line 0: [: missing `]'
[ $(uname -m)= "x86_64" ]; echo $?  # /bin/bash: line 0: [: x86_64=: unary operator expected
[ $(uname -m) ="x86_64" ]; echo $?  # /bin/bash: line 0: [: x86_64: unary operator expected

## if/elif/else/fi

arch=$(uname -m)

if [ $arch = "x86_64" ]
then
    echo 'system is 64 bit'
fi
# system is 64 bit

if [ $arch = "x86_64" ]; then
    echo 'system is 64 bit'
fi
# system is 64 bit

if [ $arch = "x86_64" ]; then echo 'system is 64 bit'; fi
# system is 64 bit

if [ $arch = "x86_64" ]; then
    echo 'system is 64 bit'
elif [ $arch = "i686" ]; then
    echo 'system is 32 bit'
fi
# system is 64 bit

if [ $arch = "x86_64" ]; then
    echo 'system is 64 bit'
elif [ $arch = "i686" ]; then
    echo 'system is 32 bit'
else
    echo 'system is unknown'
fi
# system is 64 bit

## while/until/done

i=0
while [ $i -lt 5 ]; do
    sleep 1
    i=$((i+1))
    echo "$i second(s) have passed"
done
# 1 second(s) have passed
# 2 second(s) have passed
# 3 second(s) have passed
# 4 second(s) have passed
# 5 second(s) have passed

i=0
until [ $i -ge 5 ]; do
    sleep 1
    i=$((i+1))
    echo "$i second(s) have passed"
done
# 1 second(s) have passed
# 2 second(s) have passed
# 3 second(s) have passed
# 4 second(s) have passed
# 5 second(s) have passed

## for/done

for fruit in apple orange banana; do
    echo $fruit
done
# apple
# orange
# banana

for fruit in 'apple orange banana'; do
    echo $fruit
done
# apple orange banana

for fruit in "apple orange banana"; do
    echo $fruit
done
# apple orange banana

for fruit in 'red apple' 'orange' 'banana'; do
    echo $fruit
done
# red apple
# orange
# banana

for f in *.c; do
    echo $f
done
# cat.c
# echo.c
# lock.c
# loop.c

# can NOT handle whitespace in filenames
for f in $(ls ~); do
    echo "$f"
done
# bin
# Desktop
# Documents
# Downloads
# Dropbox
# examples.desktop
# Music
# Pictures
# Public
# src
# Templates
# Videos
# VirtualBox
# VMs

# path name expansion automatically escapes whitespace
for f in $HOME/*; do
    echo $(basename "$f")
done
# bin
# Desktop
# Documents
# Downloads
# Dropbox
# examples.desktop
# Music
# Pictures
# Public
# src
# Templates
# Videos
# VirtualBox VMs

seq 5
# 1
# 2
# 3
# 4
# 5

seq 2 5
# 2
# 3
# 4
# 5

seq 2 3 9
# 2
# 5
# 8

for i in $(seq 10); do
    if [ $i -eq 3 ]; then
        continue
    elif [ $i -eq 5 ]; then
        break
    fi
    echo $i
done
# 1
# 2
# 4

## case/esac

os=$(uname -s)
case $os in
    ("Linux")
        echo "setting up for Linux"
        ;;
    "Darwin")
        echo "setting up for MacOSX"
        ;;
    "NetBSD"|"FreeBSD")
        echo "setting up for BSD"
        ;;
    *)
        echo "unsupported system"
        ;;
esac
# setting up for Linux

## functions

greet() {
    echo hello $1
}

greet world
# hello world

extract() {
    case "$1" in
        *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf "$1";;
        *.tar.gz|*.tgz) tar xzvf "$1";;
        *.tar.xz|*.txz) tar xJvf "$1";;
        *.zip) unzip "$1";;
        *.rar) unrar x "$1";;
        *.7z) 7z x "$1";;
    esac
}
