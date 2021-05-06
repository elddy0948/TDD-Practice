import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func fetchForecastByCityName() {
        
    }
    
    func fetchMockData(cityName: String) -> [Forecast]? {
        var forecastList = [Forecast]()
        
        guard let data = NSDataAsset(name: cityName, bundle: .main)?.data else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(HourlyForecast.self, from: data)
            forecastList = decodedData.forecastList
        } catch {
            print(error)
            return nil
        }
        return forecastList
    }
}
