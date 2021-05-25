import XCTest
@testable import TDDOpenWeather

class SearchCityViewControllerTests: XCTestCase {
    var sut: SearchCityViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let rootViewController = loadViewController()
        sut = rootViewController.searchCityViewController
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenViewDidLoad_navigationBarIsHidden() throws {
        sut.viewWillAppear(true)
        let unwrapGiven = try XCTUnwrap(sut.navigationController?.navigationBar.isHidden)
        XCTAssertTrue(unwrapGiven)
    }
    
    func testController_whenSearchButtonTapped_checkCitynameIsEmpty() {
        sut.searchButtonTapped(sut.searchCityView, with: nil)
        let exp = expectation(description: "alert test")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            let isAlertControllerVisible = sut.navigationController?.visibleViewController is UIAlertController
            XCTAssertTrue(isAlertControllerVisible)
        } else {
            XCTFail()
        }
    }
}
