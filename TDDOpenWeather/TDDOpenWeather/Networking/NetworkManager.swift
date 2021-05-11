import UIKit

protocol NetworkManagerProtocol {
    func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void)
    func makeURL(city: String) -> URL?
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = Privacy.shared.getAPIKey()
    let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void) {
        
        guard let url = makeURL(city: city) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalid))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let forecastList = try JSONDecoder().decode(HourlyForecast.self, from: data).forecastList
                completion(.success(forecastList))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        task.resume()
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
