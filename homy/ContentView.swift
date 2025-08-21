import SwiftUI

struct ContentView: View {
    @StateObject private var sensorManager = SensorManager()
    @State private var selectedTab = 0
    @State private var showingAddSheet = false
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        if !isOnboardingCompleted {
            OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
        } else {
            TabView(selection: $selectedTab) {
            NavigationView {
                ZStack {
                    if sensorManager.sources.isEmpty {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            Text("Add your first sensor")
                                .font(.headline)
                                .padding(.top)
                        }
                        .onTapGesture {
                            showingAddSheet = true
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(sensorManager.sources) { source in
                                    TileView(
                                        source: source,
                                        data: sensorManager.sensorData[source.id]
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Home")
                .navigationBarItems(
                    trailing: Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            SettingsView(sensorManager: sensorManager)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(1)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSourceSheet(sensorManager: sensorManager)
            }
        }
    }
}

#Preview {
    ContentView()
}
