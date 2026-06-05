import CoreWLAN
import Foundation

guard let interface = CWWiFiClient.shared().interface() else {
    print("Error: en0 not found.")
    exit(1)
}

func getSparkline(_ value: Int, minVal: Int, maxVal: Int) -> String {
    let bars = [" ", " ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
    let range = Double(maxVal - minVal)
    let normalized = Double(value - minVal) / (range > 0 ? range : 1.0)
    let index = Int(normalized * Double(bars.count - 1))
    // Using Swift's built-in min/max functions safely
    let safeIndex = Swift.max(0, Swift.min(bars.count - 1, index))
    return bars[safeIndex]
}

print("\u{001B}[2J\u{001B}[H") 
var history: [Int] = []

while true {
    let rssi = Int(interface.rssiValue())
    let noise = Int(interface.noiseMeasurement())
    let rate = interface.transmitRate()
    let snr = rssi - noise
    
    history.append(snr)
    if history.count > 50 { history.removeFirst() }
    
    let spark = history.map { getSparkline($0, minVal: 10, maxVal: 40) }.joined()
    
    // Color thresholds based on your 17dB reality
    let color = snr < 20 ? "\u{001B}[31m" : (snr < 28 ? "\u{001B}[33m" : "\u{001B}[32m")
    let reset = "\u{001B}[0m"
    
    print("\u{001B}[H") 
    print("🚀 \(color)M4 SPECTRUM-X RF DASHBOARD\(reset)")
    print("--------------------------------------------------")
    print("SIGNAL STRENGTH: \(rssi) dBm")
    print("NOISE FLOOR:     \(noise) dBm")
    print("TX THROUGHPUT:   \(rate) Mbps")
    print("--------------------------------------------------")
    print("SNR STABILITY:   [\(color)\(snr) dB\(reset)] \(snr < 20 ? "⚠️  CRITICAL" : "✅ STABLE")")
    print("JITTER TREND:    \(spark)")
    print("--------------------------------------------------")
    print("Monitoring... (Ctrl+C to stop)")
    
    fflush(stdout)
    Thread.sleep(forTimeInterval: 0.1)
}
