#!/usr/bin/env python
#
# irc.py
#
# Barebones IRC client using TCP sockets
#
# This is a simple IRC client using TCP sockets. It runs with two threads for
# reading and writing messages. The following messages that are configurable in
# this script are sent when you first connect to the server:
#
#     NICK guest123
#     USER guest123 localhost irc.libera.chat :John Doe
#
# PING messages from the server are automatically responded with a PONG
# message. No special escaped commands are provided so you are required to
# directly use the IRC protocol as such:
#
#     JOIN #python
#     PRIVMSG #python :hi folks!
#     PRIVMSG John :hi John, how are you?
#
# Input lines are terminated with CR-LF characters. Messages from all joined
# channels are displayed on the same screen. Lastly a QUIT message is sent and
# the socket is closed when the program is interrupted.
#
# IRC protocol standard: https://tools.ietf.org/html/rfc1459
#

import sys
import socket
import signal
import threading

nick = "guest123"
real = "John Doe"
host = "irc.libera.chat"
port = 6667

sock = socket.socket()
sock.connect((host, port))

sock.send(f"NICK {nick}\r\n".encode())
sock.send(f"USER {nick} localhost {host} :{real}\r\n".encode())


def reader(sock):
    while True:
        mesg = sock.recv(4096)
        toks = mesg.split()
        if toks[0] == "PING":
            sock.send(f"PONG {toks[1]}\r\n".encode())
        else:
            print(mesg.decode(), end="", flush=True)


def writer(sock):
    while True:
        line = sys.stdin.readline()
        sock.send(f"{line.rstrip()}\r\n".encode())


t1 = threading.Thread(target=reader, args=(sock,))
t2 = threading.Thread(target=writer, args=(sock,))

t1.daemon = True
t2.daemon = True

t1.start()
t2.start()

try:
    signal.pause()
except KeyboardInterrupt:
    sock.send("QUIT\r\n".encode())
    sock.close()
