import UIKit
@testable import TDDOpenWeather

func loadViewController() -> UITabBarController {
    let window = UIApplication.shared.windows[0]
    let rootViewController = window.rootViewController as! UITabBarController
    return rootViewController
}

extension UITabBarController {
    var searchCityViewController: SearchCityViewController {
        let searchCityNavigationController = children.first as! UINavigationController
        return searchCityNavigationController.children.first as! SearchCityViewController
    }
    var forecastViewController: ForecastViewController {
        let forecastViewController = ForecastViewController()
        forecastViewController.city = "Seoul"
        let searchCityNavigationController = children.first as! UINavigationController
        searchCityNavigationController.pushViewController(forecastViewController, animated: true)
        return searchCityNavigationController.children.last as! ForecastViewController
    }
}
