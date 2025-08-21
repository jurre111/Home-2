import Foundation

struct SensorData: Codable, Identifiable {
    let id = UUID()
    var temperature: Double
    var humidity: Double
}

struct SensorSource: Codable, Identifiable {
    let id = UUID()
    var url: String
    var name: String
}

class SensorManager: ObservableObject {
    @Published var sources: [SensorSource] = []
    @Published var sensorData: [String: SensorData] = [:]
    
    func addSource(_ source: SensorSource) {
        sources.append(source)
        fetchData(from: source)
    }
    
    func fetchData(from source: SensorSource) {
        guard let url = URL(string: source.url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let sensorData = try decoder.decode(SensorData.self, from: data)
                DispatchQueue.main.async {
                    self.sensorData[source.url] = sensorData
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func removeSource(_ source: SensorSource) {
        sources.removeAll { $0.id == source.id }
        sensorData.removeValue(forKey: source.url)
    }
}
