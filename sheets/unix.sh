#!/bin/sh

## manuals and documentation

whatis ls
# ls (1)               - list directory contents

whatis -w ls*
# ls (1)               - list directory contents
# lsattr (1)           - list file attributes on a Linux second extended file system
# lsb_release (1)      - print distribution-specific information
# lsblk (8)            - list block devices
# lscpu (1)            - display information about the CPU architecture
# lsdiff (1)           - show which files are modified by a patch
# lsearch (3)          - linear search of an array
# lseek (2)            - reposition read/write file offset
# lseek64 (3)          - reposition 64-bit read/write file offset
# lshw (1)             - list hardware
# lsinitramfs (8)      - list content of an initramfs image
# lsipc (1)            - show information on IPC facilities currently employed in the system
# lslocks (8)          - list local system locks
# lslogins (1)         - display information about known users in the system
# lsmod (8)            - Show the status of modules in the Linux Kernel
# lsof (8)             - list open files
# lspci (8)            - list all PCI devices
# lspcmcia (8)         - display extended PCMCIA debugging information
# lspgpot (1)          - extracts the ownertrust values from PGP keyrings and list them in ...
# lstat (2)            - get file status
# lstat64 (2)          - get file status
# lsusb (8)            - list USB devices

apropos -a list directory
# chacl (1)            - change the access control list of a file or directory
# dir (1)              - list directory contents
# File::Listing (3pm)  - parse directory listing
# ls (1)               - list directory contents
# ntfsls (8)           - list directory contents on an NTFS filesystem
# vdir (1)             - list directory contents

man ls
# (displays manual page)

manpath
# /usr/local/man:/usr/local/share/man:/usr/share/man

info ls
# (displays info page)

help cd
# (displays shell help for builtins)

type ls
# ls is /bin/ls

type cd
# cd is a shell builtin

## file displaying/editing

cat << EOF > hello.c
#include <stdio.h>

int main() {
    puts("hello world");
    return 0;
}
EOF
# (creates `hello.c` file with content up to `EOF` (heredoc literal))

cat hello.c
# #include <stdio.h>
# 
# int main() {
#     puts("hello world");
#     return 0;
# }

file hello.c
# hello.c: C source, ASCII text

file -i hello.c
# text/x-c; charset=us-ascii

gcc hello.c -o hello
# (compiles `hello.c` source into `hello` binary)

./hello
# hello world

file hello
# hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=5f4ee315765406f6c704eb194a5f624d834de000, not stripped

file -i hello
# application/x-executable; charset=binary

head -n 3 hello.c
# #include <stdio.h>
# 
# int main() {

tail -n 3 hello.c
#     puts("hello world");
#     return 0;
# }

tail -f /var/log/syslog
# (follows log file -- interrupt with Ctrl-c to quit)

more hello.c
# (displays file one page at a time)

less hello.c
# (displays file as a pager)

gedit hello.c
# (opens graphical text editor by GNOME)

nano hello.c
# (opens terminal text editor by GNU)

vi hello.c
# (opens terminal text editor -- POSIX standard)

vim hello.c
# (opens vim -- vi improved)

vimtutor
# (opens tutorial for vim)

## pipes and redirection

cat << EOF > streams.c
#include <stdio.h>

int main()
{
    fputs("this text goes to STDOUT\n", stdout);
    fputs("this text goes to STDERR\n", stderr);
    return 0;
}
EOF

gcc streams.c -o streams

./streams
# this text goes to STDERR
# this text goes to STDOUT

./streams > /dev/null
# this text goes to STDERR

./streams 1> /dev/null
# this text goes to STDERR

./streams 2> /dev/null
# this text goes to STDOUT

./streams &> /dev/null

./streams > /dev/null 2>&1

# print 5th number in a file (you should better use sed (1))
cat streams.c | head -n5 | tail -n1
#     fputs("this text goes to STDOUT\n", stdout);

# create a random string of specified length (you should better use mkpasswd (1))
cat /dev/urandom | strings -n 1 | tr -d '[:space:]' | head -c 30
# K@_Q+a)4mLI'~4#%N?))~B@^L!;i@j

# word frequency challenge (http://dl.acm.org/citation.cfm?id=5948.315654)
cat basics.sh | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | head -n5
#      24 hello
#      24 c
#      17 list
#      16 file
#      13 text

./streams | tee output.txt
# this text goes to STDERR
# this text goes to STDOUT

cat output.txt
# this text goes to STDOUT

./streams 2>&1 | tee output.txt
# this text goes to STDERR
# this text goes to STDOUT

cat output.txt
# this text goes to STDERR
# this text goes to STDOUT

## aliases and functions

# create alias for when a parameter is at the end
alias freq="cat basics.sh | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | head -n"

freq 5
#      24 hello
#      24 c
#      17 list
#      16 file
#      13 text

unalias freq

# create a function for when a parameter is at an arbitrary location
freq() { curl $1 2> /dev/null | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | head -n5; }

freq http://www.gutenberg.org/cache/epub/1342/pg1342.txt
#    4507 the
#    4243 to
#    3730 of
#    3658 and
#    2225 her

freq http://boun.edu.tr/
#     314 a
#     244 tr
#     176 class
#     158 div
#     154 href

## searching

grep hello hello.c
#     puts("hello world");

grep hello hello.c -v
# #include <stdio.h>
# 
# int main() {
#     return 0;
# }

grep hello -r .
# ./basics.sh:# create `hello.c` file with content up to `EOF` (heredoc literal)
# ./basics.sh:cat << EOF > hello.c
# ./basics.sh:    puts("hello world");
# ./basics.sh:# print `hello.c` file stdout
# ./basics.sh:cat hello.c
# ./basics.sh:#     puts("hello world");
# ./basics.sh:file hello.c
# ./basics.sh:# hello.c: C source, ASCII text
# ./basics.sh:file -i hello.c
# ./basics.sh:gcc hello.c -o hello
# ./basics.sh:./hello
# ./basics.sh:# hello world
# ./basics.sh:file hello
# ./basics.sh:# hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=5f4ee315765406f6c704eb194a5f624d834de000, not stripped
# ./basics.sh:file -i hello
# ./basics.sh:head -n 3 hello.c
# ./basics.sh:tail -n 3 hello.c
# ./basics.sh:#     puts("hello world");
# ./basics.sh:more hello.c
# ./basics.sh:less hello.c
# ./basics.sh:gedit hello.c
# ./basics.sh:nano hello.c
# ./basics.sh:vi hello.c
# ./basics.sh:vim hello.c
# ./basics.sh:#      24 hello
# ./basics.sh:#      24 hello
# ./basics.sh:# ./hello
# ./basics.sh:# ./hello.c
# ./basics.sh:# ./hello.c
# ./basics.sh:# ./hello
# ./basics.sh:# ./hello
# Binary file ./hello matches
# ./hello.c:    puts("hello world");

which ls
# /bin/ls

which vim
# /usr/local/bin/vim

which -a vim
# /usr/local/bin/vim
# /usr/bin/vim

find .
# .
# ./streams.c
# ./basics.sh
# ./hello
# ./hello.c
# ./streams

find . -name '*.c'
# ./streams.c
# ./hello.c

find . -executable
# .
# ./basics.sh
# ./hello
# ./streams

find . -executable -type f 
# ./basics.sh
# ./hello
# ./streams

# find the longest header files under `/usr/include`
find /usr/include -name '*.h' -type f -exec wc -l {} \; | sort -rn | head
# 18690 /usr/include/epoxy/gl_generated.h
# 11864 /usr/include/xcb/xproto.h
# 8424 /usr/include/xcb/glx.h
# 7126 /usr/include/valgrind/valgrind.h
# 6761 /usr/include/google/protobuf/descriptor.pb.h
# 5904 /usr/include/c++/5/bits/random.h
# 5587 /usr/include/c++/5/bits/basic_string.h
# 5546 /usr/include/c++/5/bits/stl_algo.h
# 4833 /usr/include/llvm-3.8/llvm/IR/Instructions.h
# 4698 /usr/include/valgrind/vki/vki-linux.h

ln -s basics.sh foo

test -e foo && echo 'file exists' || echo 'file does not exists'
# file exists

ln -s /path/to/non/existent/file bar

test -e bar && echo 'file exists' || echo 'file does not exists'
# file does not exists

find . -type l
# ./bar
# ./foo

find . -type l -print
# ./bar
# ./foo

find . -type l -print -print
# ./bar
# ./bar
# ./foo
# ./foo

# find existing links in current directory
find . -type l -exec test -e {} \; -print
# ./foo

# find broken links in current directory
find . -type l -! -exec test -e {} \; -print
# ./bar

locate stdio.h
# /usr/include/stdio.h
# /usr/include/c++/5/tr1/stdio.h
# /usr/include/glib-2.0/glib/gstdio.h
# /usr/include/x86_64-linux-gnu/bits/stdio.h
# /usr/lib/x86_64-linux-gnu/perl/5.22.1/CORE/nostdio.h

whereis gcc
# gcc: /usr/bin/gcc /usr/lib/gcc /usr/share/man/man1/gcc.1.gz

## packages (debian)

# search a package
apt search wget
apt-cache search wget

# show package info
apt show wget
apt-cache show wget

# install a package
sudo apt install wget
sudo apt-get install wget

# remove a package
sudo apt remove wget
sudo apt-get remove wget

# update list of packages
sudo apt update
sudo apt-get update

# upgrade all installed packages
sudo apt upgrade
sudo apt-get upgrade

# list installed files of a package
dpkg -L tree
# /.
# /usr
# /usr/bin
# /usr/bin/tree
# /usr/share
# /usr/share/doc
# /usr/share/doc/tree
# /usr/share/doc/tree/TODO
# /usr/share/doc/tree/copyright
# /usr/share/doc/tree/README.gz
# /usr/share/doc/tree/changelog.Debian.gz
# /usr/share/man
# /usr/share/man/man1
# /usr/share/man/man1/tree.1.gz

# find the owner package of a file
dpkg-query -S /bin/ls
# coreutils: /bin/ls

## archives

# create a tar file from c files
tar cf files.tar *.c

# list contents of a tar file
tar tf files.tar
# hello.c
# streams.c

# uncompress a tar file
tar xf files.tar

# create a gunzipped tar file from c files
tar czf files.tar.gz *.c

# uncompress a gunzipped tar file
tar xf files.tar

## processes

cat << EOF > loop.c
#include <stdio.h>
#include <unistd.h>

int main()
{
    int curr = 0;
    while (1) {
        printf("running for %d seconds\n", curr++);
        sleep(1);
    }
    return 0;
}
EOF

gcc loop.c -o loop

# use Ctrl-C to quit
./loop
# running for 0 seconds
# running for 1 seconds
# running for 2 seconds
# running for 3 seconds
# ^C

# use Ctrl-Z to stop
./loop
# running for 0 seconds
# running for 1 seconds
# running for 2 seconds
# running for 3 seconds
# ^Z
# [1]+  Stopped                 ./loop

jobs
# [1]+  Stopped                 ./loop

fg
# ./loop
# running for 4 seconds
# running for 5 seconds
# running for 6 seconds
# ^Z
# [1]+  Stopped                 ./loop

bg
# [1]+ ./loop &
# gokce@ext:~/Dropbox/cmpe230/basics$ running for 7 seconds
# running for 8 seconds
# running for 9 seconds
# running for 10 seconds

disown
# (abondons the last job)

disown -h
# (abondons the last job with nohup)

disown -r
# (abondons running jobs)

disown -a
# (abondons all jobs)

jobs
# (lists jobs)

ps
# (shows all processes in the current terminal)

ps -a
# (shows all processes attached to a terminal)

ps -e
# (shows all processes)

cat << EOF > lock.c
#include <stdio.h>

int main()
{
    int curr = 0;
    while (1) {
        ++curr;
    }
    return 0;
}
EOF

gcc lock.c -o lock

top
# (shows resource usage of all processes)

top -u gokce
# (shows resource usage of all processes owned by gokce)

pgrep lock
# (lists all processes with the name loop)

kill 1234
# (kills process with id 1234)

kill -9 1234
# (force kills process with id 1234)

pkill lock
# (kills all processes with the name lock)

pkill -9 lock
# (force kills all processes with the name lock)

killall lock
# (kills all processes with the exact name lock)

killall -9 lock
# (force kills all processes with the exact name lock)
