# CarImageCollections





## Tests

```swift
CarImageCollectionViewControllerTests
- testController_whenInitialize_carImageUrlsNotEmpty()
- testController_convertURLToImage_imageIsNotNil()
```



## ✅ 해결했어요!



## 🧐 고민중!

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