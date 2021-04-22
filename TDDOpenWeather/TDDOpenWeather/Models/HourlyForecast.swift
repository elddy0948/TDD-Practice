import Foundation

struct HourlyForecast: Codable {
    let cod: String
    let message, cnt: Int
    let forecastList: [Forecast]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case cod, message, cnt, city
        case forecastList = "list"
    }
}
