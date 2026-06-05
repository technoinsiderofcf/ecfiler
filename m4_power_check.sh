#!/bin/bash
echo "--- Apple M4 Power & Thermal Analytics ---"
echo "Sampling system metrics (Fast Mode)..."

# -i 500 sets the interval to 500ms
# -n 1 takes only one snapshot
# We'll use 'all' for samplers but filter heavily to ensure it works on M4
sudo powermetrics -i 500 -n 1 --samplers thermal,cpu_power,gpu_power | grep -iE "temp|power|die|thermal|cluster"

echo -e "\n--- Check Finished ---"
