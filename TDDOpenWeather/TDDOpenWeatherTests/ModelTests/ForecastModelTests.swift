//
//  ForecastModelTests.swift
//  TDDOpenWeatherTests
//
//  Created by 김호준 on 2021/04/23.
//

import XCTest
@testable import TDDOpenWeather

class ForecastModelTests: XCTestCase {
    var sut: HourlyForecast!
    var data: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        data = nil
        try super.tearDownWithError()
    }
    
    func testModel_whenCreated_MockDataThrowsError() {
        guard let data = NSDataAsset(name: "Seoul", bundle: .main)?.data else {
            XCTFail("Can't Find Data!")
            return
        }
        XCTAssertNoThrow(try JSONDecoder().decode(HourlyForecast.self, from: data))
        self.data = data
    }
}
