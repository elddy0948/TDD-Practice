# CarImageCollections

이 프로젝트에서는 CollectionView에 이미지를 다운로드 하면서 Dispatch Queue에 대한 필요성과 Dispatch Queue를 사용하면 어떤 이점이 있는지에 대한 부분에 집중한 프로젝트입니다.



- AsyncOperation의 구현 ready와 executing, finished상태에 대한 관리를 하려고 State라는 enum을 만들었습니다. 

  ```swift
      enum State: String {
          case ready, executing, finished
          fileprivate var keyPath: String {
              return "is\(rawValue.capitalized)"
          }
      }
  ```

  Operation에서 기본적으로 제공하는 Read-only 프로퍼티들인 각각의 상태들에 따라서 State 상태를 체크해주었습니다. 

  ```swift
      override var isReady: Bool {
          return super.isReady && state == .ready
      }
      override var isExecuting: Bool {
          return state == .executing
      }
      override var isFinished: Bool {
          return state == .finished
      }
      override var isAsynchronous: Bool {
          return true
      }
  ```

  또한 start() 메서드가 호출되면 취소된 상태이면 state를 finished로 바꿔주고 return, 그렇지 않으면 main()을 호출하고 state를 executing으로 바꿔주었습니다. 

  ```swift
      override func start() {
          if isCancelled {
              state = .finished
              return
          }
          main()
          state = .executing
      }
  ```

  



## Tests

```swift
CarImageCollectionViewControllerTests
- testController_whenInitialize_carImageUrlsNotEmpty()
- testController_convertURLToImage_imageIsNotNil()
```



## ✅ 해결했어요!

- 현재의 코드는 `viewDidLoad()`에서 이미지 URL을 그대로 받아와서 `carImageUrls`라는 배열에 넣어주는 것에서 끝났습니다. 그러다보니 `collectionView(_:cellForItemAt:)` 메서드에서 이미지를 다운로드 할 때 문제가 생깁니다.

  ```swift
  guard let image = convertURLToImage(url: carImageUrls[indexPath.item]) else {
      return UICollectionViewCell()
  }
  cell.setImage(with: image)
  ```

  cell이 만들어지면서 Image를 다운로드하기 때문에 스크롤을 내릴때 버벅임이 생기고 이는 좋은 User Experience가 아니라고 판단했습니다.  

  - Dispatch Queue를 활용해서 이미지를 다운로드 하자! 

    ```swift
    private func downloadWithGlobalQueue(_ indexPath: IndexPath) {
    	DispatchQueue.global(qos: .utility).async { [weak self] in
     		guard let self = self else { return }
     		let url = self.carImageUrls[indexPath.item]
    		guard let data = try? Data(contentsOf: url),
    					let image = UIImage(data: data) else {
    						return
    		}
    		DispatchQueue.main.async {
    			if let cell = self.collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell {
    				cell.setImage(with: image)
    			}
    		}
    	}
    }
    ```

    첫번째 시도는 DispatchQueue를 활용하는 방법이었습니다. 

    🧐 global? -> Serial Queue가 아니고 Concurrent Queue를 활용할 계획이었고, 현재 딱히 global queue를 사용하고 있지 않기 때문에 사용했습니다. 

    🧐 QoS가 `.utility` ? -> 물론 이미지를 다운로드 하는 기능이고, 이는 사용자에게 직접적으로 보여지는 작업이므로 .userInteractive 나 .userInitiated 를 선택할 수도 있었지만, 즉각적으로 보여주지 않아도 괜찮고, 속도와 자원에서의 균형을 맞춰도 상관없는 작업이라 더 생각이 들어서 선택하게 되었습니다. 

    해당 방법을 사용하니 스크롤시 버벅임은 줄었고, 부드러워졌지만, 다시돌아오면 이미지를 다시 로드해야하고, 다운로드 중에 화면에서 사라지면 다운로드를 취소하거나 하는 방법이 필요한 것으로 보인다! (Operation을 사용하면 가능할지도?!)

  - URLSession 사용 Dispatch Queue를 활용한 위의 방법과 같지만 애플에서 만들어 준 라이브러리이므로 성능적인 면에서 한결 더 나아진다. 

    ```swift
    private func downloadWithURLSession(_ indexPath: IndexPath) {
    	URLSession.shared.dataTask(with: carImageUrls[indexPath.item]) { [weak self] data, response, error in
    		guard let self = self else { return }
    		guard let data = data,
    					let image = UIImage(data: data) else {
    					return
    		}
    		DispatchQueue.main.async {
    			if let cell = self.collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell {
    				cell.setImage(with: image)
    			}
    		}
    	}.resume()
    }
    ```

## 🧐 고민중!

- 이미지의 다운로드가 첫번째 페이지에서만 동작하고 그 다음 페이지부터는 동작하지 않는 문제가 발생해서 그것에 대해서 알아보는 중입니다! 

  ```swift
  var cell = collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell
  ```

  우선 발견한 문제점은 해당 코드를 실행해서 cell을 가져올 때 nil값을 반환한다는 문제점이 있었습니다. 