#!/bin/bash
echo "--- M4 Active Traffic Hunter ---"
echo "Scanning for active data (3-second sample per interface)..."
echo "----------------------------------------------------------"

# List of interfaces to check
INTERFACES=(en0 en1 en2 en3 en4 en5 en6 en7 bridge0)

for iface in "${INTERFACES[@]}"; do
    # Get a 1-second sample
    # awk pulls the input packets ($3) and output packets ($6)
    DATA=$(netstat -I $iface -w 1 -c 2 | sed -n '4p')
    IN=$(echo $DATA | awk '{print $3}')
    OUT=$(echo $DATA | awk '{print $6}')

    # Only print if there is activity (greater than 0)
    if [[ "$IN" -gt 0 ]] || [[ "$OUT" -gt 0 ]]; then
        echo "INTERFACE: $iface"
        echo "   Incoming Packets: $IN"
        echo "   Outgoing Packets: $OUT"
        echo "----------------------------------------------------------"
    fi
done

echo "--- Scan Finished ---"
