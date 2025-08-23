import SwiftUI

struct SettingsView: View {
    @ObservedObject var sensorManager: SensorManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sources")) {
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
            .navigationBarItems(
                    trailing: Button() {
                        Image(systemName: "info.circle")
                    }
                )
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Link("Download the newest version", destination: URL(string: "itms-services://?action=download-manifest&url=https://github.com/jurre111/Home-2/raw/refs/heads/main/downloads/manifest.plist")!)
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
