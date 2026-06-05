import subprocess
import re
import numpy as np
import time
import sys

def get_real_snr():
    try:
        # SPAirPortDataType is slow but the most detailed
        cmd = "system_profiler SPAirPortDataType"
        output = subprocess.check_output(cmd, shell=True).decode()
        match = re.search(r"Signal / Noise: (-?\d+) dBm / (-?\d+) dBm", output)
        if match:
            return int(match.group(1)) - int(match.group(2))
    except:
        pass
    return None

print("--- M4 RF Fourier Monitor ---")
samples = []
simulated = False

# Check first sample to see if hardware is talking
first_snr = get_real_snr()
if first_snr is None or first_snr == 0:
    print("[!] Hardware Redacted. Switching to SIMULATION MODE (60Hz EMI Demo)")
    simulated = True

for i in range(32):
    if simulated:
        # Simulate a 35dB signal with a rhythmic 2dB wobble (Interference)
        snr = 35 + (2 * np.sin(i * 0.8)) + np.random.normal(0, 0.1)
    else:
        snr = get_real_snr() or 0
        
    samples.append(snr)
    print(f"Sample {i+1}/32: SNR={snr:.2f} dB", end='\r')
    time.sleep(0.05)

# FFT Calculation
signal = np.array(samples)
signal_detrended = signal - np.mean(signal)
fft_result = np.abs(np.fft.fft(signal_detrended))

print("\n\n[FFT Results - Interference Frequencies]")
print("Magnitude | Frequency Index")
for idx, mag in enumerate(fft_result[:16]):
    bar = "█" * int(mag * 5)
    print(f"{mag:9.2f} | {idx:2} {bar}")

if simulated:
    print("\nNote: You are seeing a SIMULATED 60Hz pulse pattern.")
    print("To fix hardware access: System Settings > Privacy > Location Services")
    print("Ensure 'Terminal' is allowed to access your location.")
