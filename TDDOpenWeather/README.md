# TDD OpenWeather

- App 로직을 작성하기 전에 test를 먼저 작성하자!

- Red -> Green -> Refactor!

- 네이밍 신경쓰기!

  





## 🧐 고민한 점

- ✅ Unit Test시 ViewController를 가져오는 방법?

  - 기존에 테스트 코드를 작성할 때 작성한 방법 

  - ```swift
        var sut: SearchCityViewController!
        override func setUpWithError() throws {
            try super.setUpWithError()
            sut = SearchCityViewController()
        }
    ```

    setUp() 에서 직접적으로 SearchCityViewController()를 가져와서 사용하였다.하지만 이를 개선하여 

    ```swift
    import UIKit
    @testable import TDDOpenWeather
    
    import Foundation
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
    ```

    loadViewController() 메서드에서 UIApplication에 접근하여 rootViewController를 가져온 다음, UINavigationController에서 searchCityViewController를 가져오는 코드를 작성하여

    ```swift
        var sut: SearchCityViewController!
        override func setUpWithError() throws {
            try super.setUpWithError()
            let rootViewController = loadViewController()
            sut = rootViewController.searchCityViewController
        }
    ```

    위와같은 코드로 가져올 수 있었습니다. 

- ❌ NavigationController에 push를 한 ViewController를 가져와서 테스트하는 방법?