import subprocess
import re
import numpy as np
import time
import sys

def get_router_ip():
    try:
        out = subprocess.check_output("route -n get default", shell=True).decode()
        match = re.search(r"gateway: (\d+\.\d+\.\d+\.\d+)", out)
        return match.group(1) if match else None
    except:
        return None

def get_ms(ip):
    try:
        # -c 1 (one packet), -t 1 (1 second timeout)
        out = subprocess.check_output(f"ping -c 1 -t 1 {ip}", shell=True, stderr=subprocess.STDOUT).decode()
        match = re.search(r"time=(\d+\.\d+)", out)
        return float(match.group(1)) if match else 0
    except:
        return 0

router_ip = get_router_ip()
if not router_ip:
    print("[!] Could not find default gateway. Are you connected to Wi-Fi?")
    sys.exit()

print(f"--- M4 Jitter Monitor (Target: {router_ip}) ---")
samples = []
for i in range(32):
    ms = get_ms(router_ip)
    samples.append(ms)
    print(f"Sample {i+1}/32: {ms:.2f}ms", end='\r')
    time.sleep(0.1)

data = np.array(samples)
if np.mean(data) == 0:
    print(f"\n[!] Router {router_ip} is not responding to pings (ICMP blocked).")
    sys.exit()

# FFT: Remove the average latency (DC offset) to see the 'jitter' frequencies
fft = np.abs(np.fft.fft(data - np.mean(data)))

print("\n\n[FFT Results - Interference Spectrum]")
print("Magnitude | Freq Index")
for idx, mag in enumerate(fft[:16]):
    # Scale the bar for visibility
    bar = "█" * int(mag * 3) 
    print(f"{mag:9.2f} | {idx:2} {bar}")
