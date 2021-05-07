import XCTest
@testable import TDDOpenWeather

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var url: URL!
    var forecast: [Forecast]?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager.shared
        url = sut.makeURL(city: "Seoul")
        forecast = []
    }

    override func tearDownWithError() throws {
        sut = nil
        url = nil
        forecast = nil
        try super.tearDownWithError()
    }
    
    func testNetworkManager_makeURL_urlIsNotNil() {
        XCTAssertNotNil(url)
    }
    
    func testNetworkManager_fetchForecastByCityName_forecastArrayIsNotNil() {
        let exp = expectation(description: "Fetch Forecast")
        sut.fetchForecastByCityName("Seoul") { result in
            switch result {
            case .success(let forecastList):
                self.forecast = forecastList
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(forecast)
    }
}
