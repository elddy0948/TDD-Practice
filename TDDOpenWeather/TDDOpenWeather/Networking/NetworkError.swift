import Foundation

enum NetworkError: String, Error {
    case invalid = "Something went wrong!"
    case invalidURL = "Invalid URL!"
    case invalidResponse = "Invalid Response!"
    case invalidData = "Invalid Data!"
    case decodeError = "Decoding Error!"
}
