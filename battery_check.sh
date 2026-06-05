#!/bin/bash
echo "--- M4 Battery & Thermal Status ---"
pmset -g batt | grep -i "InternalBattery"
sysctl -n machdep.cpu.brand_string
echo "Thermal Level (0=Cool, 100=Hot):"
sysctl -n kernel.thermal_level
