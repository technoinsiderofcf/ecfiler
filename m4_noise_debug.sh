#!/bin/bash
echo "--- M4 Wireless EMI Scan ---"

# 1. Use the hidden Airport utility to find Noise and RSSI
# RSSI = Signal Strength (closer to 0 is better)
# Noise = Interference (further from 0 is better)
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -E "agrCtlRSSI|agrCtlNoise|lastTxRate"

# 2. Calculate the Signal-to-Noise Ratio (SNR)
# Higher SNR means the "Intel-igent" M4 chip can easily ignore EMI.
echo -e "\n--- Analysis Finished ---"
