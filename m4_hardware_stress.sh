#!/bin/bash
echo "--- M4 Physical Link & EMI Check ---"

# 1. Check for USB/Thunderbolt Errors
echo "[USB/Thunderbolt Error Log]"
log show --predicate 'process == "kernel"' --last 1m | grep -iE "USB|Thunderbolt|Retries|Link Loss"

# 2. Check for System "Throttling" (Can be caused by EMI-induced heat spikes)
echo -e "\n[Thermal Throttling]"
pmset -g thermlog | grep -v "Note:"

echo -e "\n--- Analysis Finished ---"
