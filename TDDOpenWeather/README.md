# TDD OpenWeather

- App 로직을 작성하기 전에 test를 먼저 작성하자!
- Red -> Green -> Refactor!
- 네이밍 신경쓰기!
- **DateFormatter**, **MeasurementFormatter** 사용



## 개선해야할 사항

- [ ] Locale 을 사용하여 사용자의 지역에 맞는 시간/온도 포맷 제공하기



## Tests

```swift
ForecastModelTests
	- testModel_whenCreated_MockDataThrowsError()
ForecastViewControllerTests
	- testController_whenViewDidLoad_titleIsCityName()
SearchCityViewControllerTests
	- testController_whenViewDidLoad_navigationBarIsHidden()
	- testController_whenSearchButtonTapped_isTextFieldStringCome()
```



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

- ⚠️ NavigationController에 SearchCityViewController를 push한 뒤에 ForecastViewController를 push하여 테스트 하기 위해 

  ```swift
  extension UINavigationController {
      var searchCityViewController: SearchCityViewController {
          return children.first as! SearchCityViewController
      }
      
      var forecastViewController: ForecastViewController {
          searchCityViewController.didTappedSearchButton(searchCityViewController.searchButton)
          return children.last as! ForecastViewController
      }
  }
  ```

  이런식으로 코드를 작성하여 가지고왔다. 하지만 이렇게 코드를 동작시키면 **testController_whenViewDidLoad_navigationBarIsHidden** 해당 SearchCityViewController의 테스트가 제대로 작동하지 않았다. 아마 순서의 문제일 것 같다 테스트를 동시에 돌리지 않고 하나하나 작동하면 잘 돌아가는데 전체를 테스트하면 잘 동작하지 않았다. 

  -> 우선은 test코드에 viewWillAppear를 호출해주고, SearchCityViewController에 navigationbar 를 설정해주는 부분을 viewWillAppear로 따로 빼주는 선택을 하였다. 더 좋은방법을 알아보기위해 검색이 더 필요한 부분!

