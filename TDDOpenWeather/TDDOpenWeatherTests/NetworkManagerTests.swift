import XCTest
@testable import TDDOpenWeather

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManagerProtocol!
    var url: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockNetworkManager()
        url = sut.makeURL(city: "Seoul")
    }

    override func tearDownWithError() throws {
        sut = nil
        url = nil
        try super.tearDownWithError()
    }
    
    func testNetworkManager_makeURL_urlIsNotNil() {
        XCTAssertNotNil(url)
    }
    
    func testNetworkManager_fetchForecastByCityName_forecastArrayIsNotNil() {
        sut.fetchForecastByCityName("Seoul") { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
    }
}
