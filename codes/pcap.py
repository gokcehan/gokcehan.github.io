#!/usr/bin/env python3
#
# pcap.py
#
# Pcap file decoder for the standard TCP/IP stack
#
# This is a basic decoder for TCP packets composed of IP and ETH packets within
# a pcap file. Other types of packets are simply denoted with 'UNK' and are not
# decoded any further. This is used for post-mortem analysis of network traffic
# captured beforehand.
#
# As an example use, `tcpdump` can be used to capture packets to a pcap file:
#
#     sudo tcpdump -w example.pcap
#
# Output file can then be given to this script to print the decoded output:
#
#     ./pcap.py example.pcap
#
# An example output of this script is as follows:
# 
#     -- ETH Layer -- Tue Jun  5 10:52:34 2012 -- 54 bytes
#             src: 00:12:cf:e5:54:a0
#             dst: 00:1f:3c:23:db:d3
#             typ: 8
#             -- IP Layer --
#                     src: 192.168.10.226
#                     dst: 192.168.11.12
#                     typ: 6
#                     -- TCP Layer --
#                             src: 64332
#                             dst: 5888
#                             seq: 1492699879
#                             ack: 3729068838
#                             dat: b''
#     -- ETH Layer -- Tue Jun  5 10:52:35 2012 -- 60 bytes
#             src: 00:1f:3c:23:db:d3
#             dst: 00:12:cf:e5:54:a0
#             typ: 8
#             -- IP Layer --
#                     src: 192.168.11.12
#                     dst: 192.168.10.226
#                     typ: 6
#                     -- TCP Layer --
#                             src: 5888
#                             dst: 64332
#                             seq: 3729068838
#                             ack: 1509477095
#                             dat: b'\x00\x00\x00\x00\x00\x00'
#
# Indentation follows packet levels so that you can utilize folding feature in
# your text editor to display packets at the desired level. Following settings
# are used for vim editor:
#
#     set foldmethod=indent
#     set foldenable
#     set foldlevel=0 " only show packets
#     set foldlevel=1 " decode ETH layer
#     set foldlevel=2 " decode IP layer
#     set foldlevel=3 " decode TCP layer
#
# You can also directly read from stdin as follows:
#
#     ./pcap example.pcap | vim -
#


import sys
import time
import struct

if len(sys.argv) < 2:
    sys.stderr.write('usage: {} [PCAP_FILE]\n'.format(sys.argv[0]))
    sys.exit(1)

def decode_eth(packet):
    src = struct.unpack('6B', packet[0:6])
    dst = struct.unpack('6B', packet[6:12])
    typ = struct.unpack('H', packet[12:14])[0]
    return src, dst, typ

def decode_ip(packet):
    typ = struct.unpack('B', packet[9:10])[0]
    src = struct.unpack('4B', packet[12:16])
    dst = struct.unpack('4B', packet[16:20])
    return src, dst, typ

def decode_tcp(packet):
    src = struct.unpack('H', packet[0:2])[0]
    dst = struct.unpack('H', packet[2:4])[0]
    seq = struct.unpack('I', packet[4:8])[0]
    ack = struct.unpack('I', packet[8:12])[0]
    return src, dst, seq, ack

with open(sys.argv[1], 'rb') as f:
    bom, major, minor, off, cap, typ = struct.unpack('IHHQII', f.read(24))
    if typ != 1:
        sys.stderr.write('error: only ethernet frame is supported\n')
        sys.exit(1)

    while True:
        header = f.read(16)
        if not header:
            break

        sec, msec, real, size = struct.unpack('IIII', header)
        print('-- ETH Layer --', time.ctime(sec), '--', size, 'bytes')
        packet = f.read(size)

        eth_src, eth_dst, eth_typ = decode_eth(packet)
        print('\tsrc:', ':'.join("%02x" % i for i in eth_src))
        print('\tdst:', ':'.join("%02x" % i for i in eth_dst))
        print('\ttyp:', eth_typ)

        if eth_typ != 8:
            print('\t-- UNK Layer --')
            print('\t\tdat:', packet[14:])
            continue

        ip_src, ip_dst, ip_typ = decode_ip(packet[14:])
        print('\t-- IP Layer --')
        print('\t\tsrc:', '.'.join(str(i) for i in ip_src))
        print('\t\tdst:', '.'.join(str(i) for i in ip_dst))
        print('\t\ttyp:', ip_typ)

        if ip_typ != 6:
            print('\t\t-- UNK Layer --')
            print('\t\t\tdat:', packet[34:])
            continue

        tcp_src, tcp_dst, tcp_seq, tcp_ack = decode_tcp(packet[34:])
        print('\t\t-- TCP Layer --')
        print('\t\t\tsrc:', tcp_src)
        print('\t\t\tdst:', tcp_dst)
        print('\t\t\tseq:', tcp_seq)
        print('\t\t\tack:', tcp_ack)
        print('\t\t\tdat:', packet[54:])
