#!/bin/bash
echo "--- M4 Active Network Traffic ---"
echo "Checking for data movement on all interfaces..."
echo "------------------------------------------------"

# This uses netstat to show 1-second snapshots of activity
# We filter for 'en' and 'bridge' devices that have non-zero traffic
netstat -I en0 -I en1 -I en2 -I en3 -I en4 -I en5 -I en6 -I en7 -I bridge0 -w 1 -c 3 | awk '
NR==3 {print "Interface activity (Packets In/Out per second):"}
$3 > 0 || $6 > 0 {print $0}'

echo "------------------------------------------------"
echo "[Interface Guide]"
echo "en0/en1: Physical (Wi-Fi/Ethernet)"
echo "en2-en7: Virtual (Docker/VMs/VPN)"
echo "bridge0: The internal switch connecting them"
echo "--- Monitor Finished ---"
