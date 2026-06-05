#!/bin/bash
echo "--- Apple M4 System Health ---"

# 1. Get exact CPU brand
sysctl -n machdep.cpu.brand_string

# 2. Get Battery Health
echo -e "\n[Battery Status]"
pmset -g batt | grep -i "InternalBattery"

# 3. Find Thermal Sensors (M4 Specific Fallback)
echo -e "\n[Thermal/Fan Status]"
# We try to find any OID that mentions thermal or fan
THERMAL_INFO=$(sysctl -a 2>/dev/null | grep -iE "thermal|fan" | grep -v "not available")

if [ -z "$THERMAL_INFO" ]; then
    echo "Direct thermal OIDs are hidden. Use 'powermetrics' for deep Intel-style data."
else
    echo "$THERMAL_INFO"
fi

echo -e "\n--- Check Finished ---"
