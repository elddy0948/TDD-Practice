import XCTest
@testable import TDDOpenWeather

class ForecastViewControllerTests: XCTestCase {
    var sut: ForecastViewController!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = loadViewController().forecastViewController
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenViewDidLoad_navigationBarIsNotHidden() throws {
        sut.viewDidLoad()
        let barIsHidden = try XCTUnwrap(sut.navigationController?.navigationBar.isHidden)
        XCTAssertFalse(barIsHidden)
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
