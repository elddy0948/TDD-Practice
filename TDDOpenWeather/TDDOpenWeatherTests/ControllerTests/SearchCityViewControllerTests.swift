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
        let unwrapGiven = try XCTUnwrap(sut.navigationController?.navigationBar.isHidden)
        XCTAssertTrue(unwrapGiven)
    }
    
    func testController_whenSearchButtonTapped_isTextFieldStringCome() {
        sut.cityTextField.text = "Seoul"
        //when
        sut.didTappedSearchButton(sut.searchButton)
        //then
        XCTAssertEqual(sut.city, sut.cityTextField.text)
    }
}
