import SwiftUI

struct TileView: View {
    let source: SensorSource
    let data: SensorData?
    
    var body: some View {
        VStack(spacing: 12) {
            Text(source.name)
                .font(.headline)
            
            if let data = data {
                VStack(spacing: 8) {
                    DataRow(icon: "thermometer", value: String(format: "%.1f°C", data.temperature))
                    DataRow(icon: "humidity", value: String(format: "%.1f%%", data.humidity))
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct DataRow: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(value)
                .bold()
        }
    }
}
