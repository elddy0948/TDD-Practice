import Foundation
@testable import TDDOpenWeather

class MockNetworkManager: NetworkManagerProtocol {
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = Privacy.shared.getAPIKey()
    
    func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void) {
        guard let url = makeURL(city: city) else {
            completion(.failure(.invalidURL))
            return
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let queryCity = components?.queryItems?.first else {
            completion(.failure(.invalid))
            return
        }
        
        if queryCity.name == "q" && queryCity.value! == city {
            completion(.success([]))
            return
        }
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
