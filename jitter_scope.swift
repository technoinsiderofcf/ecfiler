import CoreWLAN
import Foundation

guard let interface = CWWiFiClient.shared().interface() else { exit(1) }

print("\u{001B}[2J\u{001B}[H")
var lastTime = CFAbsoluteTimeGetCurrent()
var history: [Double] = []
var maxJitter: Double = 0

while true {
    let now = CFAbsoluteTimeGetCurrent()
    let delta = (now - lastTime) * 1000
    let jitter = abs(delta - 100.0) 
    lastTime = now
    
    if jitter > maxJitter { maxJitter = jitter }
    history.append(jitter)
    if history.count > 50 { history.removeFirst() }
    
    let avg = history.reduce(0, +) / Double(history.count)
    let rssi = interface.rssiValue()
    let rate = interface.transmitRate()
    
    let spark = history.map { j -> String in
        if j < 3.0 { return " " }
        if j < 10.0 { return "▃" }
        return "█"
    }.joined()

    print("\u{001B}[H")
    print("🚀 M4 JITTER-SCOPE V2 | INTERFERENCE DETECTOR")
    print("--------------------------------------------------")
    print("SIGNAL: \(rssi) dBm | RATE: \(rate) Mbps")
    print("AVG JITTER: \(String(format: "%.2f", avg)) ms")
    print("PEAK SPIKE: \(String(format: "%.2f", maxJitter)) ms")
    print("--------------------------------------------------")
    print("PULSE: \(spark)")
    print("--------------------------------------------------")
    
    if maxJitter > 50 {
        print("⚠️  CRITICAL COLLISION: A device just 'blinded' the radio.")
        maxJitter = 0 // Reset after alert
    }
    
    fflush(stdout)
    Thread.sleep(forTimeInterval: 0.1)
}
