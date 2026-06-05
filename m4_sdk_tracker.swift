import CoreWLAN
import Foundation

// Initialize the Wi-Fi Interface
guard let interface = CWWiFiClient.shared().interface() else {
    print("Error: Could not find Wi-Fi interface (en0).")
    exit(1)
}

print("\u{001B}[2J\u{001B}[H") // Clear screen
var lastBSSID = ""

while true {
    let bssid = interface.bssid() ?? "REDACTED/SEARCHING"
    let ssid = interface.ssid() ?? "UNKNOWN"
    let rssi = interface.rssiValue()
    let rate = interface.transmitRate()
    let channel = interface.wlanChannel()?.channelNumber ?? 0
    let band = channel < 14 ? "2.4GHz" : "5GHz"
    
    // Tracking for "BSSID Flapping"
    var alert = ""
    if lastBSSID != "" && bssid != lastBSSID && bssid != "REDACTED/SEARCHING" {
        alert = "🚨 BSSID CHANGE DETECTED (UUID FLAP)"
    }
    lastBSSID = bssid

    print("\u{001B}[H") // Move cursor to top
    print("🛰️  M4 SDK LIVE NETWORK TRACKER")
    print("--------------------------------------------------")
    print("ACTIVE SSID:   \(ssid)")
    print("ROUTER UUID:   \(bssid)")
    print("RF CHANNEL:    \(channel) (\(band))")
    print("--------------------------------------------------")
    print("SIGNAL STRENGTH: \(rssi) dBm")
    print("CURRENT RATE:    \(rate) Mbps")
    print("--------------------------------------------------")
    
    if alert != "" { print(alert) }
    
    // Status Logic for Jitter
    if rssi < -70 {
        print("STATUS: ⚠️  MARGINAL SIGNAL (Jitter likely)")
    } else if rate < 200 {
        print("STATUS: ⚠️  LOW THROUGHPUT (Check Interference)")
    } else {
        print("STATUS: ✅ OPTIMAL")
    }
    
    fflush(stdout)
    Thread.sleep(forTimeInterval: 0.2) // 5Hz Refresh
}
