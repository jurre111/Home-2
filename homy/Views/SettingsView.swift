import SwiftUI

struct SettingsView: View {
    @ObservedObject var sensorManager: SensorManager
    
    var body: some View {
        NavigationView {
            List {
                Section("Sources") {
                    ForEach(sensorManager.sources) { source in
                        VStack(alignment: .leading) {
                            Text(source.name)
                                .font(.headline)
                            Text(source.url)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            sensorManager.removeSource(sensorManager.sources[index])
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
