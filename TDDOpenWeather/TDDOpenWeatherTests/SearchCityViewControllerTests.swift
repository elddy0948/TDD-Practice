//
//  SearchCityViewControllerTests.swift
//  TDDOpenWeatherTests
//
//  Created by 김호준 on 2021/04/22.
//

import XCTest
@testable import TDDOpenWeather

class SearchCityViewControllerTests: XCTestCase {
    var sut: SearchCityViewController!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SearchCityViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenSearchButtonTapped_isTextFieldStringCome() {
        //when
        sut.didTappedSearchButton(sut.searchButton)
        //then
        XCTAssertEqual(sut.city, sut.cityTextField.text)
    }
}
