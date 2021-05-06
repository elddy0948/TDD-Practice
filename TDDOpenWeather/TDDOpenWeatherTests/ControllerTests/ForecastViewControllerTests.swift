import XCTest
@testable import TDDOpenWeather

class ForecastViewControllerTests: XCTestCase {
    var sut: ForecastViewController!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ForecastViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenViewDidLoad_titleIsCityName() {
        //given
        sut.city = "Seoul"
        //when
        sut.viewDidLoad()
        //then
        XCTAssertEqual(sut.title, sut.city)
    }
}
