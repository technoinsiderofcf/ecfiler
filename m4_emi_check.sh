#!/bin/bash
echo "--- M4 Interference & Signal Report ---"

# 1. Check Wi-Fi Noise level
# Lower (more negative) is better. -90 is great, -60 is high interference.
echo "[Wireless Environment]"
wdutil info | grep -E "RSSI|Noise|Channel|Channel Width"

# 2. Check for Hardware Errors/Retries
echo -e "\n[Network Error Rates]"
netstat -i | grep -E "Name|en0"

# 3. Check for Power Instability
echo -e "\n[Power Delivery Context]"
sudo powermetrics -n 1 --samplers cpu_power | grep -E "Combined Power|Thermal level"

echo -e "\n--- Analysis Finished ---"
echo "Tip: If 'Noise' is higher than -70 dBm, you have significant EMI."
