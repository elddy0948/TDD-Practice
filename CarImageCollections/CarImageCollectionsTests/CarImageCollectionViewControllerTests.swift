import XCTest
@testable import CarImageCollections

class CarImageCollectionViewControllerTests: XCTestCase {
    var sut: CarImageCollectionViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "CarImageCollectionViewController") as? CarImageCollectionViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenInitialize_carImageUrlsNotEmpty() {
        if sut.carImageUrls.isEmpty { XCTFail() }
        else { XCTAssert(true) }
    }
    
    func testController_convertURLToImage_imageIsNotNil() {
        let url = sut.carImageUrls.first!
        let image = sut.convertURLToImage(url: url)
        XCTAssertNotNil(image)
    }
}
