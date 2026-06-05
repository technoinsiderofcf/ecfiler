import CoreWLAN
import Foundation

guard let interface = CWWiFiClient.shared().interface() else {
    print("[!] No Wi-Fi Interface found.")
    exit(1)
}

print("--- M4 SDK RF Monitor (CoreWLAN) ---")
print("Press Ctrl+C to stop\n")

while true {
    let rssi = interface.rssiValue()
    let noise = interface.noiseMeasurement()
    let rate = interface.transmitRate()
    let snr = rssi - noise
    
    // Clear line and print updated stats
    print("\rRSSI: \(rssi) dBm | Noise: \(noise) dBm | SNR: \(snr) dB | Tx: \(rate) Mbps", terminator: "")
    fflush(stdout)
    
    Thread.sleep(forTimeInterval: 0.2)
}
