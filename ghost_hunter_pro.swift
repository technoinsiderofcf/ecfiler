import CoreWLAN
import Foundation

guard let client = CWWiFiClient.shared().interface() else { 
    print("Error: No Wi-Fi interface."); exit(1) 
}

print("\u{001B}[2J\u{001B}[H") // Clear

while true {
    let currentBSSID = client.bssid() ?? "N/A"
    let currentRSSSI = client.rssiValue()
    let currentRate = client.transmitRate()
    let currentChannel = client.wlanChannel()?.channelNumber ?? 0
    
    // Perform a targeted scan of nearby networks
    var scanResults: [CWNetwork] = []
    do {
        scanResults = Array(try client.scanForNetworks(withName: nil)).sorted { $0.rssiValue > $1.rssiValue }
    } catch { }

    print("\u{001B}[H") // Back to top
    print("🚀 M4 GHOST HUNTER PRO | BSSID TRACKER")
    print("--------------------------------------------------")
    print("CONNECTED TO: \(client.ssid() ?? "Unknown")")
    print("BSSID:        \(currentBSSID)")
    print("CHANNEL:      \(currentChannel) (\(currentChannel < 14 ? "2.4GHz" : "5GHz"))")
    print("SIGNAL/RATE:  \(currentRSSSI) dBm / \(currentRate) Mbps")
    print("--------------------------------------------------")
    print("TOP NEARBY UUIDs (INTERFERENCE SOURCES):")
    
    for (index, network) in scanResults.prefix(5).enumerated() {
        let isHome = network.bssid == currentBSSID ? "*" : " "
        let ch = network.wlanChannel?.channelNumber ?? 0
        print("\(isHome) [\(index)] \(network.bssid ?? "??"): CH \(ch) | \(network.rssiValue) dBm | \(network.ssid ?? "HIDDEN")")
    }
    
    print("--------------------------------------------------")
    if currentRSSSI < -75 {
        print("⚠️  SIGNAL DROOP: High probability of Index 11 Jitter.")
    }
    
    fflush(stdout)
    Thread.sleep(forTimeInterval: 1.0) // Scanning too fast can cause lag
}
