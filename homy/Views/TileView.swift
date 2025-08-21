import SwiftUI

struct TileView: View {
    let source: SensorSource
    let data: SensorData?
    
    var timeAgoString: String {
        guard let lastUpdate = source.lastUpdate else { return "Never updated" }
        let seconds = Date().timeIntervalSince(lastUpdate)
        
        switch seconds {
        case ..<60:
            return "Just now"
        case 60..<3600:
            let minutes = Int(seconds / 60)
            return "\(minutes)m ago"
        case 3600..<86400:
            let hours = Int(seconds / 3600)
            return "\(hours)h ago"
        default:
            let days = Int(seconds / 86400)
            return "\(days)d ago"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(source.name)
                    .font(.headline)
                Spacer()
                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let data = data {
                VStack(spacing: 12) {
                    DataRow(
                        icon: "thermometer",
                        value: String(format: "%.1f°C", data.temperature),
                        color: temperatureColor(data.temperature)
                    )
                    DataRow(
                        icon: "humidity.fill",
                        value: String(format: "%.1f%%", data.humidity),
                        color: humidityColor(data.humidity)
                    )
                }
            } else {
                VStack {
                    ProgressView()
                        .padding(.vertical, 8)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func temperatureColor(_ temp: Double) -> Color {
        switch temp {
        case ..<18:
            return .blue
        case 18..<22:
            return .green
        case 22..<26:
            return .yellow
        default:
            return .red
        }
    }
    
    private func humidityColor(_ humidity: Double) -> Color {
        switch humidity {
        case ..<30:
            return .red
        case 30..<40:
            return .orange
        case 40..<60:
            return .green
        case 60..<70:
            return .blue
        default:
            return .purple
        }
    }
}

struct DataRow: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .bold()
                .foregroundColor(color)
            Spacer()
        }
    }
}
