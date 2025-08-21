import Foundation

struct SensorData: Codable, Identifiable {
    let id = UUID()
    var temperature: Double
    var humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
    }
    
    // Custom init to handle decoding and ID generation
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(Double.self, forKey: .temperature)
        humidity = try container.decode(Double.self, forKey: .humidity)
    }
    
    init(temperature: Double, humidity: Double) {
        self.temperature = temperature
        self.humidity = humidity
    }
}

struct SensorSource: Codable, Identifiable, Equatable {
    let id: UUID
    var url: String
    var name: String
    var lastUpdate: Date?
    
    init(url: String, name: String) {
        self.id = UUID()
        self.url = url
        self.name = name
        self.lastUpdate = nil
    }
}

class SensorManager: ObservableObject {
    @Published var sources: [SensorSource] = []
    @Published var sensorData: [UUID: SensorData] = [:]
    private var timers: [UUID: Timer] = [:]
    
    init() {
        // Load saved sources from UserDefaults
        if let savedSources = UserDefaults.standard.data(forKey: "savedSources"),
           let decoded = try? JSONDecoder().decode([SensorSource].self, from: savedSources) {
            self.sources = decoded
            // Start fetching for all saved sources
            decoded.forEach { source in
                startFetching(for: source)
            }
        }
    }
    
    func addSource(_ source: SensorSource) {
        sources.append(source)
        saveSources()
        startFetching(for: source)
    }
    
    private func saveSources() {
        if let encoded = try? JSONEncoder().encode(sources) {
            UserDefaults.standard.set(encoded, forKey: "savedSources")
        }
    }
    
    private func startFetching(for source: SensorSource) {
        // Initial fetch
        fetchData(from: source)
        
        // Set up timer for periodic fetching (every 30 seconds)
        let timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.fetchData(from: source)
        }
        timers[source.id] = timer
    }
    
    func fetchData(from source: SensorSource) {
        guard let url = URL(string: source.url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Fetch error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let sensorData = try decoder.decode(SensorData.self, from: data)
                
                DispatchQueue.main.async {
                    self.sensorData[source.id] = sensorData
                    // Update last update time
                    if let index = self.sources.firstIndex(where: { $0.id == source.id }) {
                        var updatedSource = self.sources[index]
                        updatedSource.lastUpdate = Date()
                        self.sources[index] = updatedSource
                        self.saveSources()
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
    
    func removeSource(_ source: SensorSource) {
        // Stop the timer
        timers[source.id]?.invalidate()
        timers.removeValue(forKey: source.id)
        
        // Remove the source and its data
        sources.removeAll { $0.id == source.id }
        sensorData.removeValue(forKey: source.id)
        saveSources()
    }
    
    deinit {
        // Clean up all timers
        timers.values.forEach { $0.invalidate() }
    }
}
