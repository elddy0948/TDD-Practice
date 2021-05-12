import Foundation
@testable import TDDOpenWeather

class MockNetworkManager: NetworkManagerProtocol {
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = Privacy.shared.getAPIKey()
    
    func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void) {
        guard city != "" else {
            completion(.failure(.invalid))
            return
        }
        completion(.success([]))
    }
    
    func makeURL(city: String) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else {
            return nil
        }
        
        return url
    }
}
