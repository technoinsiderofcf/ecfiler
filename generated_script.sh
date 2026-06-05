#!/bin/bash
echo "--- System Hardware Check ---"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # This is the macOS way to get CPU info
    echo "Hardware: $(sysctl -n machdep.cpu.brand_string)"
    echo "Architecture: $(uname -m)"
else
    # This is the standard Linux way
    grep -m 1 "model name" /proc/cpuinfo || echo "CPU: $(uname -m)"
fi

echo "--- Check Finished ---"
