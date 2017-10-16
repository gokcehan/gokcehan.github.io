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

## path navigation and file/dir manipulation

pwd
# /home/gokce/Dropbox/cmpe230/basics

cd ..
# (change to parent directory)

cd basics
# (change to 'basics' directory -- relative path)

cd ~
# (change to home directory)

cd /etc
# (change to '/etc' directory -- full path)

cd
# (change to home directory)

cd -
# (change to previous directory)

mkdir demo
rmdir demo
# (creates and then removes 'demo' directory)

mkdir demo
touch demo/foo.txt
rmdir demo
# rmdir: failed to remove 'demo': Directory not empty

mkdir demo/foo/bar/baz
# mkdir: cannot create directory ‘demo/foo/bar/baz’: No such file or directory

mkdir -p demo/foo/bar/baz
rmdir /demo/foo/bar/baz
rmdir /demo/foo/bar
rmdir /demo/foo
# (creates 'demo/foo/bar/baz' along with its parents and then remove them)

cp demo/foo.txt demo/bar.txt
# (copies 'demo/foo.txt' to 'demo/bar.txt')

cp demo demo2
# cp: omitting directory 'demo'

cp -r demo demo2
# (copies 'demo' directory to 'demo2')

mv demo2 demo3
# (moves 'demo2' directory to 'demo3')

rm demo3
# rm: cannot remove 'demo3': Is a directory

rm -r demo3
# (removes 'demo3' directory)

ln demo/foo.txt hard
# (creates an hard link named 'hard' to 'demo/foo.txt')

rm hard
# (removes 'hard' file)

ln -s demo/foo.txt soft
# (creates a soft link named 'soft' to 'demo/foo.txt')

rm soft
# (removes 'soft' link)

## file displaying/editing

cat << 'EOF' > hello.c
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

cat << 'EOF' > streams.c
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
cat streams.c | head -n 5 | tail -n 1
#     fputs("this text goes to STDOUT\n", stdout);

# create a random string of specified length (you should better use mkpasswd (1))
cat /dev/urandom | strings -n 1 | tr -d '[:space:]' | head -c 30
# K@_Q+a)4mLI'~4#%N?))~B@^L!;i@j

# word frequency challenge (http://dl.acm.org/citation.cfm?id=5948.315654)
cat basics.sh | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | head -n 5
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

./streams 2>&1 | tee -a output.txt
# this text goes to STDERR
# this text goes to STDOUT

cat output.txt
# this text goes to STDERR
# this text goes to STDOUT
# this text goes to STDERR
# this text goes to STDOUT

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
# Binary file ./src.tar matches
# ./basics.sh:cat << 'EOF' > hello.c
# ./basics.sh:    puts("hello world");
# ...
# ./basics.sh:# (copies `hello.html` file from the remote server)
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
# ./lock.c
# ./streams.c
# ./echo
# ./cat.c
# ./basics.sh
# ./hello
# ./hello.c
# ./cat
# ./mnt
# ./src.tar
# ./loop.c
# ./demo
# ./demo/foo.txt
# ./demo/bar.txt
# ./hello.html
# ./output.txt
# ./src.tar.gz
# ./bar
# ./loop
# ./echo.c
# ./lock
# ./1342-0.txt
# ./foo
# ./streams

find . -name '*.c'
# ./lock.c
# ./streams.c
# ./cat.c
# ./hello.c
# ./loop.c
# ./echo.c

find . -executable
# .
# ./echo
# ./hello
# ./cat
# ./mnt
# ./demo
# ./loop
# ./lock
# ./streams

find . -executable -type f 
# ./echo
# ./hello
# ./cat
# ./loop
# ./lock
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

# find the total line of code in the current directory
find . -name '*.[ch]' -type f -exec wc -l {} +

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

## commands

echo $PATH | tr : '\n'
# /home/gokce/bin
# /usr/local/sbin
# /usr/local/bin
# /usr/sbin
# /usr/bin
# /sbin
# /bin
# /usr/games
# /usr/local/games
# /snap/bin

type mkdir
# mkdir is /bin/mkdir

type -a cd
# cd is a shell builtin

type -a echo
# echo is a shell builtin
# echo is /bin/echo

type grep
# grep is aliased to `grep --color=auto'

type ./hello
# ./hello is ./hello

cat << 'EOF' > cat.c
#include <stdio.h>

main()
{
    int c;
    while ((c = getchar()) != EOF)
        putchar(c);
}
EOF

gcc cat.c -o cat

./cat < basics.sh > basics-copy.sh

diff basics.sh basics-copy.sh

rm basics-copy.sh

cat << 'EOF' > echo.c
#include <stdio.h>

main(int argc, char *argv[])
{
    while (--argc > 0)
        printf("%s%s", *++argv, (argc > 1) ? " " : "");
    printf("\n");
}
EOF

gcc echo.c -o echo

./echo hello world
# hello world

# create an alias when a parameter is at the end
alias loc="find . -name '*.[ch]' -type f -exec wc -l {} + | sort -rn | head -n"

loc 5
# 54 total
# 12 ./loop.c
# 10 ./lock.c
#  9 ./echo.c
#  9 ./cat.c

unalias loc

# create a function when a parameter is at an arbitrary location
loc() { find "$1" -name '*.[ch]' -type f -exec wc -l {} + | sort -rn | head; }

loc .
# 54 total
# 12 ./loop.c
# 10 ./lock.c
#  9 ./echo.c
#  9 ./cat.c
#  8 ./streams.c
#  6 ./hello.c

## packages

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
tar cf src.tar *.c

# list contents of a tar file
tar tf src.tar
# cat.c
# echo.c
# hello.c
# lock.c
# loop.c
# streams.c

# uncompress a tar file
tar xf src.tar

# create a gunzipped tar file from c files
tar czf src.tar.gz *.c

# uncompress a gunzipped tar file
tar xzf src.tar.gz

## processes

cat << 'EOF' > loop.c
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

cat << 'EOF' > lock.c
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

## networking

ping example.com
# PING example.com (93.184.216.34) 56(84) bytes of data.
# 64 bytes from 93.184.216.34: icmp_seq=1 ttl=51 time=152 ms
# 64 bytes from 93.184.216.34: icmp_seq=2 ttl=51 time=211 ms
# ^C
# --- example.com ping statistics ---
# 2 packets transmitted, 2 received, 0% packet loss, time 1001ms
# rtt min/avg/max/mdev = 152.815/182.286/211.757/29.471 ms

ping -c 3 example.com
# PING example.com (93.184.216.34) 56(84) bytes of data.
# 64 bytes from 93.184.216.34: icmp_seq=1 ttl=51 time=204 ms
# 64 bytes from 93.184.216.34: icmp_seq=2 ttl=51 time=226 ms
# 64 bytes from 93.184.216.34: icmp_seq=3 ttl=51 time=250 ms
# 
# --- example.com ping statistics ---
# 3 packets transmitted, 3 received, 0% packet loss, time 2002ms
# rtt min/avg/max/mdev = 204.275/227.099/250.269/18.782 ms

hostname
# (displays your hostname)

hostname -I
# (displays your IP address)

arp
# Address                  HWtype  HWaddress           Flags Mask            Iface
# ardic.cc.boun.edu.tr             (incomplete)                              eno1
# xxx.xxx.xxx.1            ether   xx:xx:xx:xx:xx:xx   C                     eno1
# tesla.me.boun.edu.tr     ether   xx:xx:xx:xx:xx:xx   C                     eno1
# simurg.cc.boun.edu.tr            (incomplete)                              eno1

arp -n
# Address                  HWtype  HWaddress           Flags Mask            Iface
# xxx.xxx.xxx.20                   (incomplete)                              eno1
# xxx.xxx.xxx.1            ether   xx:xx:xx:xx:xx:xx   C                     eno1
# xxx.xxx.xxx.69           ether   xx:xx:xx:xx:xx:xx   C                     eno1
# xxx.xxx.xxx.50                   (incomplete)                              eno1

traceroute example.com
# traceroute to example.com (93.184.216.34), 30 hops max, 60 byte packets
#  1  193.140.197.1 (193.140.197.1)  4.925 ms  5.146 ms  5.806 ms
#  2  192.168.200.1 (192.168.200.1)  2.868 ms  3.289 ms  3.378 ms
#  3  192.168.192.70 (192.168.192.70)  0.760 ms  0.774 ms  0.932 ms
#  4  193.140.194.1 (193.140.194.1)  1.435 ms  1.449 ms  1.684 ms
#  5  193.255.0.217 (193.255.0.217)  3.011 ms  3.018 ms  3.221 ms
#  6  193.140.0.149 (193.140.0.149)  9.441 ms  8.718 ms  9.585 ms
#  7  host-85-29-25-9.reverse.superonline.net (85.29.25.9)  8.929 ms  9.135 ms  9.180 ms
#  8  * * *
#  9  * * *
# 10  * * *
# 11  * * *
# 12  * * *
# 13  * * *
# 14  ix-ae-10-0.tcore1.IT5-Istanbul.as6453.net (5.23.0.37)  13.802 ms  13.814 ms  13.787 ms
# 15  if-ae-8-2.tcore1.FNM-Frankfurt.as6453.net (195.219.156.21)  63.382 ms  63.929 ms  62.853 ms
# 16  if-ae-12-2.tcore2.FNM-Frankfurt.as6453.net (195.219.87.1)  51.188 ms  54.153 ms  61.829 ms
# 17  ffm-b1-link.telia.net (213.248.82.40)  55.953 ms  57.335 ms  55.975 ms
# 18  ffm-bb3-link.telia.net (62.115.137.128)  56.951 ms  53.125 ms ffm-bb4-link.telia.net (62.115.137.166)  54.949 ms
# 19  ash-bb4-link.telia.net (62.115.141.108)  150.267 ms hbg-bb4-link.telia.net (213.155.135.141)  69.194 ms ash-bb4-link.telia.net (62.115.141.108)  157.538 ms
# 20  ash-b1-link.telia.net (213.155.136.39)  159.854 ms kbn-bb3-link.telia.net (62.115.115.96)  74.760 ms ash-b1-link.telia.net (213.155.136.39)  146.984 ms
# 21  edgecast-ic-315151-ash-b1.c.telia.net (195.12.254.154)  150.414 ms edgecast-ic-315152-ash-b1.c.telia.net (213.155.141.226)  149.454 ms edgecast-ic-315151-ash-b1.c.telia.net (195.12.254.154)  147.807 ms
# 22  nyk-bb3-link.telia.net (80.91.247.127)  138.630 ms 152.195.65.133 (152.195.65.133)  154.188 ms 152.195.64.133 (152.195.64.133)  156.731 ms
# 23  93.184.216.34 (93.184.216.34)  151.871 ms  152.085 ms ash-b1-link.telia.net (80.91.248.157)  150.086 ms

netstat -i
# Kernel Interface table
# Iface   MTU Met   RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
# eno1       1500 0    590598      0      0 0        235380      0      0      0 BMRU
# lo        65536 0       534      0      0 0           534      0      0      0 LRU

netstat -r
# Kernel IP routing table
# Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
# default         xxx.xxx.xxx.1   0.0.0.0         UG        0 0          0 eno1
# link-local      *               255.255.0.0     U         0 0          0 eno1
# xxx.xxx.xxx.2   xxx.xxx.xxx.1   255.255.255.255 UGH       0 0          0 eno1
# xxx.xxx.xxx.0   *               255.255.255.0   U         0 0          0 eno1

netstat -rn
# Kernel IP routing table
# Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
# 0.0.0.0         xxx.xxx.xxx.1   0.0.0.0         UG        0 0          0 eno1
# xxx.xxx.xxx.0   0.0.0.0         255.255.0.0     U         0 0          0 eno1
# xxx.xxx.xxx.2   xxx.xxx.xxx.1   255.255.255.255 UGH       0 0          0 eno1
# xxx.xxx.xxx.0   0.0.0.0         255.255.255.0   U         0 0          0 eno1

netstat -s
# (display statistics for each protocol)

netstat
# (displays all open ports)

netstat -l
# (displays all listening ports)

netstat -p
# (displays all open ports with program names)

sudo tcpdump
# (captures all network packets)

sudo tcpdump -n
# (captures all network packets without converting addresses)

sudo tcpdump port 22
# (captures all network packets using src or dst port 22)

sudo tcpdump port 20 or port 21
# (captures all network packets using port 20 or 21)

sudo tcpdump port 80 -A
# (captures all network packets using port 80 and print in ascii form)

sudo tcpdump -w foo.pcap
# (captures all network packets and save to `foo.pcap` file)

tcpdump -r foo.pcap port 80 -A
# (select all network packets in `foo.pcap` file using port 80 and print in ascii form)

ifconfig
# eno1      Link encap:Ethernet  HWaddr xx:xx:xx:xx:xx:xx  
#           inet addr:xxx.xxx.xxx.xxx  Bcast:xxx.xxx.xxx.255  Mask:255.255.255.0
#           inet6 addr: fe80::b3b3:46b1:7592:cb6/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:604008 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:238267 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000 
#           RX bytes:608197341 (608.1 MB)  TX bytes:31493090 (31.4 MB)
#           Interrupt:20 Memory:ec100000-ec120000 
# 
# lo        Link encap:Local Loopback  
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:534 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:534 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000 
#           RX bytes:42160 (42.1 KB)  TX bytes:42160 (42.1 KB)
# 

sudo ifconfig eno1 down
# (disables eno1 interface)

sudo ifconfig eno1 hw ether 00:00:00:00:00:01
# (change MAC address of eno1 interface)

sudo ifconfig eno1 mtu 1492
# (change MTU size of eno1 interface)

sudo ifconfig eno1 up
# (enables eno1 interface)

sudo ifdown eno1
# (disables eno1 interface)

sudo ifup eno1
# (enables eno1 interface)

ip addr
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#     inet 127.0.0.1/8 scope host lo
#        valid_lft forever preferred_lft forever
#     inet6 ::1/128 scope host 
#        valid_lft forever preferred_lft forever
# 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
#     link/ether 00:00:00:00:00:01 brd ff:ff:ff:ff:ff:ff
#     inet xxx.xxx.xxx.49/24 brd 193.140.197.255 scope global dynamic eno1
#        valid_lft 1197sec preferred_lft 1197sec
#     inet6 fe80::b3b3:46b1:7592:cb6/64 scope link 
#        valid_lft forever preferred_lft forever

ip link
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
# 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
#     link/ether 00:00:00:00:00:01 brd ff:ff:ff:ff:ff:ff

ip route
# default via xxx.xxx.xxx.1 dev eno1  proto static  metric 100 
# xxx.xxx.xxx.0/16 dev eno1  scope link  metric 1000 
# xxx.xxx.xxx.2 via xxx.xxx.xxx.1 dev eno1  proto dhcp  metric 100 
# xxx.xxx.xxx.0/24 dev eno1  proto kernel  scope link  src xxx.xxx.xxx.124  metric 100 

sudo ip link set eno1 down
# (disables eno1 interface)

sudo ip link set eno1 up
# (enables eno1 interface)

nslookup example.com
# Server:         193.140.192.20
# Address:        193.140.192.20#53
# 
# Non-authoritative answer:
# Name:   example.com
# Address: 93.184.216.34

nslookup example.com 8.8.8.8
# Server:		8.8.8.8
# Address:	8.8.8.8#53
# 
# Non-authoritative answer:
# Name:	example.com
# Address: 93.184.216.34
# 

nslookup 93.184.216.34
# Server:         193.140.192.20
# Address:        193.140.192.20#53
# 
# ** server can't find 34.216.184.93.in-addr.arpa.: NXDOMAIN

host example.com
# example.com has address 93.184.216.34
# example.com has IPv6 address 2606:2800:220:1:248:1893:25c8:1946

host example.com 8.8.8.8
# Using domain server:
# Name: 8.8.8.8
# Address: 8.8.8.8#53
# Aliases: 
# 
# example.com has address 93.184.216.34
# example.com has IPv6 address 2606:2800:220:1:248:1893:25c8:1946

host 93.184.216.34
# Host 34.216.184.93.in-addr.arpa. not found: 3(NXDOMAIN)

dig example.com
# ; <<>> DiG 9.10.3-P4-Ubuntu <<>> example.com
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 27151
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3
# 
# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 4096
# ;; QUESTION SECTION:
# ;example.com.			IN	A
# 
# ;; ANSWER SECTION:
# example.com.		27485	IN	A	93.184.216.34
# 
# ;; AUTHORITY SECTION:
# example.com.		27485	IN	NS	b.iana-servers.net.
# example.com.		27485	IN	NS	a.iana-servers.net.
# 
# ;; ADDITIONAL SECTION:
# a.iana-servers.net.	1072	IN	A	199.43.135.53
# b.iana-servers.net.	1072	IN	A	199.43.133.53
# 
# ;; Query time: 237 msec
# ;; SERVER: 193.140.192.20#53(193.140.192.20)
# ;; WHEN: Sat Sep 23 17:33:00 +03 2017
# ;; MSG SIZE  rcvd: 136
# 

dig @8.8.8.8 example.com
# ; <<>> DiG 9.10.3-P4-Ubuntu <<>> @8.8.8.8 example.com
# ; (1 server found)
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46070
# ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
# 
# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 512
# ;; QUESTION SECTION:
# ;example.com.			IN	A
# 
# ;; ANSWER SECTION:
# example.com.		50153	IN	A	93.184.216.34
# 
# ;; Query time: 37 msec
# ;; SERVER: 8.8.8.8#53(8.8.8.8)
# ;; WHEN: Sat Sep 23 17:34:27 +03 2017
# ;; MSG SIZE  rcvd: 56
# 

cat << 'EOF' > hello.html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Title of the document</title>
</head>
<body>
Hello World!
</body>
</html> 
EOF

python -m SimpleHTTPServer
# Serving HTTP on 0.0.0.0 port 8000 ...
# 127.0.0.1 - - [23/Sep/2017 18:18:15] "GET /hello.html HTTP/1.1" 200 -
# 127.0.0.1 - - [23/Sep/2017 18:18:36] "GET /hello.html HTTP/1.1" 200 -

telnet localhost 8000
# Trying 127.0.0.1...
# Connected to localhost.
# Escape character is '^]'.
# GET /hello.html HTTP/1.1
# 
# HTTP/1.0 200 OK
# Server: SimpleHTTP/0.6 Python/2.7.12
# Date: Sat, 23 Sep 2017 14:47:38 GMT
# Content-type: text/html
# Content-Length: 135
# Last-Modified: Sat, 23 Sep 2017 14:41:22 GMT
# 
# <!DOCTYPE html>
# <html>
# <head>
# <meta charset="UTF-8">
# <title>Title of the document</title>
# </head>
# <body>
# Hello World!
# </body>
# </html>
# Connection closed by foreign host.

printf "GET /hello.html HTTP/1.1\r\n\r\n" | nc localhost 8000
# HTTP/1.0 200 OK
# Server: SimpleHTTP/0.6 Python/2.7.12
# Date: Sat, 23 Sep 2017 15:18:36 GMT
# Content-type: text/html
# Content-Length: 135
# Last-Modified: Sat, 23 Sep 2017 14:41:22 GMT
# 
# <!DOCTYPE html>
# <html>
# <head>
# <meta charset="UTF-8">
# <title>Title of the document</title>
# </head>
# <body>
# Hello World!
# </body>
# </html>

python -m smtpd -n -c DebuggingServer localhost:8025
# ---------- MESSAGE FOLLOWS ----------
# Body of email.
# ------------ END MESSAGE ------------
# ---------- MESSAGE FOLLOWS ----------
# Body of email.
# ------------ END MESSAGE ------------

telnet localhost 8025
# Trying 127.0.0.1...
# Connected to localhost.
# Escape character is '^]'.
# 220 ext Python SMTP proxy version 0.2
# HELO host.example.com
# MAIL FROM:<user@host.example.com>
# RCPT TO:<user2@host.example.com>
# DATA
# Body of email.
# .
# QUIT
# 250 ext
# 250 Ok
# 250 Ok
# 354 End data with <CR><LF>.<CR><LF>
# 250 Ok
# 221 Bye
# Connection closed by foreign host.

printf "HELO host.example.com\r
MAIL FROM:<user@host.example.com>\r
RCPT TO:<user2@host.example.com>\r
DATA\r
Body of email.\r
.\r
QUIT\r\n" | nc localhost 8025
# 220 ext Python SMTP proxy version 0.2
# 250 ext
# 250 Ok
# 250 Ok
# 354 End data with <CR><LF>.<CR><LF>
# 250 Ok
# 221 Bye

nc -l 1234 < hello.html
# (listens port 1234 to send `hello.html`)

nc localhost 1234
# <!DOCTYPE html>
# <html>
# <head>
# <meta charset="UTF-8">
# <title>Title of the document</title>
# </head>
# <body>
# Hello World!
# </body>
# </html>

ssh user@example.com
# (connects to `example.com` as `user`)

scp hello.html user@example.com:~
# (copies `hello.html` file to the remote server)

scp user@example.com:~/hello.html .
# (copies `hello.html` file from the remote server)

rsync hello.html user@example.com:~
# (copies `hello.html` file to the remote server)

rsync user@example.com:~/hello.html .
# (copies `hello.html` file from the remote server)

mkdir mnt
# (creates an empty folder for mounting)

sshfs user@example.com:/home/user mnt
# (mounts home directory of the remote server to `mnt` folder)

fusermount -u mnt
# (unmounts `mnt` folder)

curl example.com
# <!doctype html>
# <html>
# <head>
#     ..
# </head>
# 
# <body>
# <div>
#     <h1>Example Domain</h1>
#     <p>This domain is established to be used for illustrative examples in documents. You may use this
#     domain in examples without prior coordination or asking for permission.</p>
#     <p><a href="http://www.iana.org/domains/example">More information...</a></p>
# </div>
# </body>
# </html>

wget http://www.gutenberg.org/files/1342/1342-0.txt
# (retrieves the file in the given link)
