#!/bin/bash
echo "--- M4 Physical Connection Map ---"

# 1. List USB/Thunderbolt Devices and their speeds
# 480 Mb/s = USB 2.0 (Slow)
# 5 Gb/s or 10 Gb/s = USB 3 (Fast)
# 40 Gb/s = Thunderbolt (Ultra Fast)
system_profiler SPUSBDataType | grep -E "Product ID|Speed"

# 2. Check for active Ethernet/Network links
echo -e "\n[Network Link Status]"
networksetup -listallhardwareports | grep -A1 "Device"

echo -e "\n--- Scan Finished ---"
