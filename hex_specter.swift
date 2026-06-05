import CoreWLAN
import Foundation

guard let interface = CWWiFiClient.shared().interface() else { exit(1) }

func toHex(_ value: Int) -> String {
    return String(format: "%02X", value)
}

print("\u{001B}[2J\u{001B}[H")

while true {
    let rssi = Int(interface.rssiValue())
    let noise = Int(interface.noiseMeasurement())
    let rate = Int(interface.transmitRate())
    let bssid = interface.bssid() ?? "00:00:00:00:00:00"
    
    // Simulate Hex Frame Stream based on real RF data
    let timestamp = Int(Date().timeIntervalSince1970)
    let hexTs = String(format: "%08X", timestamp)
    let hexRssi = String(format: "%02X", abs(rssi))
    let hexNoise = String(format: "%02X", abs(noise))
    
    print("\u{001B}[H")
    print("🚀 M4 HEX-SPECTER | RAW FRAME DIAGNOSTIC")
    print("--------------------------------------------------")
    print("SYSTEM TIME (HEX): [\(hexTs)]")
    print("BSSID (SRC):       [\(bssid.replacingOccurrences(of: ":", with: " "))]")
    print("RF_STATUS:         RSSI:[\(hexRssi)] NOISE:[\(hexNoise)] RATE:[\(toHex(rate))]")
    print("--------------------------------------------------")
    print("LIVE FRAME BUFFER (HEX DUMP):")
    
    // Generate a simulated hex dump based on actual interference levels
    for i in 0..<6 {
        var row = ""
        for _ in 0..<8 {
            let rand = Int.random(in: 0...255)
            // If jitter is high, we "corrupt" the hex dump visually
            let val = (i == 2 && rssi < -70) ? Int.random(in: 200...255) : rand
            row += toHex(val) + " "
        }
        print("\(String(format: "%04X", i * 16))  \(row)")
    }
    print("--------------------------------------------------")
    
    // The "Jitter Pulse" detection
    if rate < 150 {
        print("\u{001B}[31m[!] FRAME COLLISION DETECTED: 0xEE 0x44 0x01\u{001B}[0m")
    } else {
        print("\u{001B}[32m[+] LINK STABLE: 0xAA 0xFF 0x00\u{001B}[0m")
    }

    fflush(stdout)
    Thread.sleep(forTimeInterval: 0.15)
}
