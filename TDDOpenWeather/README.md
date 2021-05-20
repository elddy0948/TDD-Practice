# TDD OpenWeather

OpenWeatherMap.org 의 5 Day / 3 Hour Forecast API를 활용하여 지역을 검색하면 그 지역의 3시간 단위의 날씨를 가져오는 토이 프로젝트입니다.

## 목록
- [사용한 기술](#used-skill)
- [Tests](#tests-section)
- [해결해 봤어요!](#solved-problems)
- [고민한 점](#think-point)



## <a name="used-skill">사용한 기술</a>
- **DateFormatter**, **MeasurementFormatter** 사용했습니다.

  ```swift
  extension Date {
      func getLocalDate() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.timeStyle = .short
          dateFormatter.dateStyle = .none
          dateFormatter.timeZone = .current
          let localDate = dateFormatter.string(from: self)
          return localDate
      }
  }
  ```

  ```swift
  extension Double {
      func convertTemperature(from: UnitTemperature, to: UnitTemperature) -> String {
          let measurementFormatter = MeasurementFormatter()
          measurementFormatter.numberFormatter.maximumFractionDigits = 0
          measurementFormatter.unitOptions = .providedUnit
          let input = Measurement(value: self, unit: from)
          let output = input.converted(to: to)
          return measurementFormatter.string(from: output)
      }
  }
  ```

  ```swift
  //Cell에 데이터를 보여줄 때
  tempLabel.text = forecast.main.temp.convertTemperature(from: .kelvin, to: .celsius)
  timeDataLabel.text = Date(timeIntervalSince1970: forecast.dt).getLocalDate()
  ```

- **NSCache**를 활용하여 UIImage 저장하여 ImageView에서 이미지를 Fetch할 때 Cache에 이미지가 이미 있다면, cache에서 이미지를 가져오도록 구성해보았습니다.

  ```swift
  //NetworkManager.swift
  let cache = NSCache<NSString, UIImage>()
  ```

  ```swift
  //WeatherIconImageView.swift
  private let cache = NetworkManager.shared.cache
  
  func fetchImage(imageName: String) {
  	let urlString = imageURL + "\(imageName)@2x.png"
  	let cacheKey = NSString(string: urlString)
         
  	if let image = cache.object(forKey: cacheKey) {
  		self.image = image
  		return
  	}
    //...
    
  	let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
  		guard let self = self  else { return }
  		//...
  		guard let image = UIImage(data: data) else {
  			return
  		}        
  		self.cache.setObject(image, forKey: cacheKey)
  		//...
  	}
  }
  ```

- **CoreData**를 활용하여 즐겨찾기 기능을 구현하였습니다. 

  CoreData에 저장되어있는 FavoriteCity 모델을 가져오는 메서드입니다.

  ```swift
  func loadSavedData() -> [FavoriteCity]? {
  	var favoriteCity: [FavoriteCity] = []
  	let request = FavoriteCity.createFetchRequest()
  	do {
  		favoriteCity = try container.viewContext.fetch(request)
  		return favoriteCity
  	} catch {
  		return nil
  	}
  }
  ```

  City를 저장하는 메서드입니다. 

  ```swift
  func insertCity(city: String) {
  	let entity = NSEntityDescription.entity(forEntityName: "FavoriteCity", in: self.container.viewContext)
  	if let entity = entity {
  		let managedObject = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
  		managedObject.setValue(city, forKey: "name")
  		do {
  			try self.container.viewContext.save()
  		} catch {
  			print(error)
  		}
  	}
  }
  ```

  City를 삭제하는 메서드입니다.

  ```swift
  func delete(object: NSManagedObject) {
  	self.container.viewContext.delete(object)
    do {
    	try self.container.viewContext.save()
    } catch {
    	print(error)
  	}
  }
  ```

  

## <a name="tests-section">Tests</a>

```swift
ForecastModelTests
	- testModel_whenCreated_MockDataThrowsError()

ForecastViewControllerTests
	- testController_whenViewDidLoad_navigationBarIsNotHidden()
	- testController_whenViewDidLoad_titleIsCityName()
	- testController_whenViewDidLoad_rightBarbuttonItemIsNotNil()
	- testController_whenAlreadyInFavorite_buttonIsStarFill()
	- testController_whenNotInFavorite_buttonIsStar()
	- testController_whenDidTappedFavoriteButton_favoriteButtonIsToggled()

SearchCityViewControllerTests
	- testController_whenViewDidLoad_navigationBarIsHidden()
	- testController_whenSearchButtonTapped_isTextFieldStringCome()

NetworkManagerTests
	- testNetworkManager_makeURL_urlIsNotNil()
	- testNetworkManager_fetchForecastByCityName_forecastArrayIsNotNil()
```
## <a name="solved-problems">✅ 해결해 봤어요!</a>


- Unit Test시 ViewController를 가져오는 방법?
  기존에 테스트 코드를 작성할 때 작성한 방법 

  ```swift
      var sut: SearchCityViewController!
      override func setUpWithError() throws {
          try super.setUpWithError()
          sut = SearchCityViewController()
      }
  ```

  setUp() 에서 직접적으로 SearchCityViewController()를 가져와서 사용했습니다. 하지만 이를 개선하여 

  ```swift
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

- 네트워크 Request를 할 때 "**api.openweathermap.org/data/2.5/forecast**" 로 요청을 날리면 'unsupportedURL' 이라는 에러메시지가 나옵니다.  "**https://api.openweathermap.org/data/2.5/forecast**" https://를 꼭 붙여줘야 합니다.

-  Network Test를 진행할 때 Network상태에 따라 Test의 성공 여부가 갈리는 테스트는 좋지 않은 테스트입니다. 그렇기 때문에 MockNetworkmanager를 만들어 Test시 사용할 Class를 따로 만들어주었습니다.

  ```swift
  protocol NetworkManagerProtocol {
      func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void)
      func makeURL(city: String) -> URL?
  }
  ```

  NetworkManager 의 Test에서 `testNetworkManager_makeURL_urlIsNotNil()` 를 통해서 이미 URL이 잘 만들어지고 있는지를 검증 받기 때문에, fetchForecastByCityName를 테스트 할 때에는 비어있는 city로 검색을 하려하지는 않는지에 대한 테스트만 있으면 괜찮다고 생각했습니다. 

  ```swift
  //MockNetworkManager.swift
  func fetchForecastByCityName(_ city: String, completion: @escaping (Result<[Forecast], NetworkError>) -> Void) {
  	guard city != "" else {
  		completion(.failure(.invalid))
  		return
  	}
  	completion(.success([]))
  }
  ```

  ```swift
  func testNetworkManager_fetchForecastByCityName_forecastArrayIsNotNil() {
  	sut.fetchForecastByCityName("Seoul") { result in
  		switch result {
  		case .success(_):
  			XCTAssert(true)
  		case .failure(_):
  			XCTFail()
  		}
  	}
  }
  ```

  

## <a name="think-point">🧐 고민한 점</a>

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

  이런식으로 코드를 작성하여 가지고왔습니다. 하지만 이렇게 코드를 동작시키면 **testController_whenViewDidLoad_navigationBarIsHidden** 해당 SearchCityViewController의 테스트가 제대로 작동하지 않았다. 아마 순서의 문제일 것 같다 테스트를 동시에 돌리지 않고 하나하나 작동하면 잘 돌아가는데 전체를 테스트하면 잘 동작하지 않았습니다. 

  -> 우선은 test코드에 viewWillAppear를 호출해주고, SearchCityViewController에 navigationbar 를 설정해주는 부분을 viewWillAppear로 따로 빼주는 선택을 하였습니다. 더 좋은방법을 알아보기위해 검색이 더 필요한 부분!
  
- CoreData의 Unit Test?




## App

![Simulator Screen Recording - iPhone 12 - 2021-05-21 at 02 18 41](https://user-images.githubusercontent.com/40102795/119021873-e7ecd880-b9da-11eb-92db-64fe226c8a2a.gif)![Simulator Screen Shot - iPhone 12 - 2021-05-21 at 02 20 02](https://user-images.githubusercontent.com/40102795/119022255-62b5f380-b9db-11eb-84b4-53b170159219.png)





