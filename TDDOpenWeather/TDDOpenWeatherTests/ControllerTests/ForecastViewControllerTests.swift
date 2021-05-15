import XCTest
@testable import TDDOpenWeather

class ForecastViewControllerTests: XCTestCase {
    var sut: ForecastViewController!
    var rightBarButtonItem: UIBarButtonItem!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = loadViewController().forecastViewController
        sut.city = "Seoul"
        sut.viewDidLoad()
        rightBarButtonItem = sut.navigationItem.rightBarButtonItem
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testController_whenViewDidLoad_navigationBarIsNotHidden() throws {
        let barIsHidden = try XCTUnwrap(sut.navigationController?.navigationBar.isHidden)
        XCTAssertFalse(barIsHidden)
    }
    
    func testController_whenViewDidLoad_titleIsCityName() {
        XCTAssertEqual(sut.title, sut.city)
    }
    
    func testController_whenViewDidLoad_rightBarbuttonItemIsNotNil() {
        XCTAssertNotNil(rightBarButtonItem)
    }
    
    func testController_whenAlreadyInFavorite_buttonIsStarFill() {
        sut.favorites.append("Seoul")
        sut.viewDidLoad()
        rightBarButtonItem = sut.navigationItem.rightBarButtonItem
        XCTAssertEqual(rightBarButtonItem.image, UIImage(systemName: "star.fill"))
    }
    
    func testController_whenNotInFavorite_buttonIsStar() {
        sut.favorites.removeAll()
        sut.viewDidLoad()
        rightBarButtonItem = sut.navigationItem.rightBarButtonItem
        XCTAssertEqual(rightBarButtonItem.image, UIImage(systemName: "star"))
    }
    
    func testController_whenDidTappedFavoriteButton_favoriteButtonIsToggled() {
        let button = sut.navigationItem.rightBarButtonItem!
        let currentImage = button.image!
        sut.didTappedFavoriteButton(button)
        XCTAssertNotEqual(currentImage, sut.navigationItem.rightBarButtonItem?.image!)
    }
}
