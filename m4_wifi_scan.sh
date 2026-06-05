#!/bin/bash
echo "--- M4 Wireless EMI & Environment Scan ---"

# This command forces a scan of the current hardware interface
# It bypasses the deprecated 'airport' tool
device=$(networksetup -listallhardwareports | grep -A1 "Wi-Fi" | grep "Device" | awk '{print $2}')

echo "Checking Device: $device"
echo "------------------------------------------"

# Getting the raw details
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport $device -I | grep -E "agrCtlRSSI|agrCtlNoise|lastTxRate|maxRate"

# If the above is still blank, we use the 'wdutil' diagnostic sweep
if ! /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport $device -I | grep -q "RSSI"; then
    echo "Standard info hidden. Running diagnostic info..."
    wdutil info | grep -A 15 "WIFI" | grep -E "RSSI|Noise|Tx Rate"
fi

echo "------------------------------------------"
echo "--- Scan Finished ---"
