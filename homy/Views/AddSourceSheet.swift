import SwiftUI

struct AddSourceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var sensorManager: SensorManager
    @State private var url = ""
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Source Details") {
                    TextField("Name", text: $name)
                    TextField("URL", text: $url)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
            }
            .navigationTitle("Add Source")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let source = SensorSource(url: url, name: name)
                    sensorManager.addSource(source)
                    dismiss()
                }
                .disabled(url.isEmpty || name.isEmpty)
            )
        }
    }
}
