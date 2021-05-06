import Foundation


struct Forecast: Codable {
    let dt: Double
    let main: WeatherMain
    let weather: [Weather]
    let clouds: [String: Int]
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: [String: String]
    let dtTxt: String
    let rain: [String: Double]?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

struct WeatherMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
