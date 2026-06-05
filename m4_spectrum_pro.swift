import CoreWLAN
import Foundation

guard let interface = CWWiFiClient.shared().interface() else { exit(1) }

print("\u{001B}[2J\u{001B}[H")
while true {
    let rssi = interface.rssiValue()
    let rate = interface.transmitRate()
    let bssid = interface.bssid() ?? "UNKNOWN"
    let channel = interface.wlanChannel()?.channelNumber ?? 0
    let ssid = interface.ssid() ?? "HIDDEN"
    
    print("\u{001B}[H")
    print("🚀 M4 ADVANCED RF MONITOR")
    print("--------------------------------------------------")
    print("SSID:      \(ssid)")
    print("BSSID/UUID:\(bssid)  (Target ID)")
    print("CHANNEL:   \(channel)                (Freq: \(channel > 14 ? "5GHz" : "2.4GHz"))")
    print("--------------------------------------------------")
    print("SIGNAL:    \(rssi) dBm")
    print("SPEED:     \(rate) Mbps")
    print("--------------------------------------------------")
    print("Monitoring Hardware ID Persistence... (Ctrl+C)")
    
    Thread.sleep(forTimeInterval: 0.5)
}
