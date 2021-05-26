# CarImageCollections

이 프로젝트에서는 CollectionView에 이미지를 다운로드 하면서 Dispatch Queue에 대한 필요성과 Dispatch Queue를 사용하면 어떤 이점이 있는지에 대한 부분에 집중한 프로젝트입니다.

또한 Operation을 활용하여 이미지를 다운로드해보는 연습도 해보았습니다.

## 목차

- [구현내용](#used-skill)
- [해결한점](#think-finish)
- [고민중](#thinking-now)



## <a name="used-skill">구현내용</a>

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

- Operation Cancel 구현

  CollectionView에서 사용자가 스크롤을 빨리 내려서 다운로드를 취소해야 할 때를 대비하여 `collectionView(_:didEndDisplaying:_:)`에서 cancel메서드를 호출해 주었습니다.

  ```swift
  override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  	if let operation = operations[indexPath] {
  		operation.cancel()
  	}
  }
  ```

  또한 Operation을 구현하는 코드에서 dataTask를 실행 시 isCancelled 상태를 확인하여 return시키는 코드 또한 추가했습니다. 

  ```swift
  task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
  	//Some Code...
  	guard !self.isCancelled else { return }
  	//Some Code...
  }
  ```

  **CarImageOperation**에서의 `cancel()` 구현

  ```swift
  override func cancel() {
  	super.cancel()
  	task?.cancel()
  }
  ```

- **DispatchSemaphore**를 활용하여 이미지를 2개씩 다운받을 수 있게 구현해보았습니다. 

  ```swift
  let semaphore = DispatchSemaphore(value: 2)
  
  func fetchImageByTwo(with url: URL, completion: @escaping (UIImage?) -> Void) {
  	semaphore.wait() //Task를 시작하기 직전에 wait
  	print("Semaphore IN!")
  	let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
  		print("Done")
  		guard let self = self else { return }
  		defer { self.semaphore.signal() } //이 블록을 나갈때 무조건 signal()
  		guard let data = data,
  		let image = UIImage(data: data) else {
  			completion(nil)
  			return
      }
  	completion(image)
  	}
  	task.resume()
  }
  ```

  ```swift
  dispatchQueue.async {
  	cell.downloadImage(url: url, type: .semaphore)
  }
  ```

  

## Tests

```swift
CarImageCollectionViewControllerTests
- testController_whenInitialize_carImageUrlsNotEmpty()
- testController_convertURLToImage_imageIsNotNil()
```



## <a name="think-finish">해결한 점</a>

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

    해당 방법을 사용하니 스크롤시 버벅임은 줄었고, 부드러워졌지만, 다시돌아오면 이미지를 다시 로드해야하고, 다운로드 중에 화면에서 사라지면 다운로드를 취소하거나 하는 방법이 필요한 것으로 보입니다! (Operation을 사용하면 가능할지도?!)

  - URLSession 사용 Dispatch Queue를 활용한 위의 방법과 같지만 애플에서 만들어 준 라이브러리이므로 성능적인 면에서 한결 더 나아졌습니다. 

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

- 이미지의 다운로드가 첫번째 페이지에서만 동작하고 그 다음 페이지부터는 동작하지 않는 문제가 발생해서 그것에 대해서 알아보는 중입니다! 

  ```swift
  var cell = collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell
  ```

  우선 발견한 문제점은 해당 코드를 실행해서 cell을 가져올 때 nil값을 반환한다는 문제점이 있었습니다. 

  - ImageView의 이미지를 바꾸는 시점에 대해서 고민해보았습니다. ImageView가 Configure될 때 즉, Cell이 만들어질 때 url을 주어서 다운로드할 수 있게 해주었습니다. 

    ```swift
    //CollectionViewController.swift
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarImageCollectionViewCell.reuseIdentifier, for: indexPath) as? CarImageCollectionViewCell else {
    	return UICollectionViewCell()
    }
    let url = carImageUrls[indexPath.item]
    cell.downloadImage(url: url)
    return cell
    ```

    ```swift
    //CarImageCollectionViewCell.swift
    func downloadImage(url: URL) {
    	URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
    		guard let self = self else { return }
    		guard let data = data,
    					let image = UIImage(data: data) else {
    						return
              }
    		DispatchQueue.main.async {
    			self.carImageView.image = image
    		}
    	}.resume()
    }
    ```

  - Operation의 경우에는 Operation에서 이미지를 다운로드 받아온 후 image를 설정해주는 로직으로 작성하여서 단순하게 이미지만 바꿔주면 되었습니다. 

    ```swift
    let downloadOperation = CarImageOperation(url: urls[indexPath.item])
    downloadOperation.completionBlock = {
    	DispatchQueue.main.async {
    		cell.carImageView.image = downloadOperation.image
    	}
    }
    queue.addOperation(downloadOperation)
    ```

- 기존에 구현했던 코드로 cell을 정의할 때 느린 네트워크 상태에서 테스트를 해보니 이미지가 다운로드되기 전 까지 아무것도 할 수 없는 문제점이 발견되었습니다. 기존의 코드는 이런식으로 다운로드 해주고 있었는데, 

  ```swift
  cell.downloadImage(url: url, type: .normal)
  ```

  이를 DispatchQueue 내부에 넣어주었습니다.

  ```swift
  DispatchQueue.global().async {
  	cell.downloadImage(url: url, type: .normal)
  }
  ```



## <a name="thinking-now">고민중!</a>





## App

![Simulator Screen Recording - iPhone 12 - 2021-05-26 at 16 56 23](https://user-images.githubusercontent.com/40102795/119624050-bbeeae80-be43-11eb-8030-4a68225a77ce.gif)![Simulator Screen Recording - iPhone 12 - 2021-05-26 at 16 57 29](https://user-images.githubusercontent.com/40102795/119624059-bdb87200-be43-11eb-9161-ac34e9abc1ab.gif)![Simulator Screen Recording - iPhone 12 - 2021-05-26 at 16 58 11](https://user-images.githubusercontent.com/40102795/119624067-c01acc00-be43-11eb-8416-bc4a19814924.gif)

제일 우측이 Semaphore를 이용한 다운로드입니다!
