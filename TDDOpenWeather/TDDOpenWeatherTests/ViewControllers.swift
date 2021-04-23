import UIKit
@testable import TDDOpenWeather

func loadViewController() -> UINavigationController {
    let window = UIApplication.shared.windows[0]
    let rootViewController = window.rootViewController as! UINavigationController
    
    return rootViewController
}

extension UINavigationController {
    var searchCityViewController: SearchCityViewController {
        return children.first as! SearchCityViewController
    }
}
