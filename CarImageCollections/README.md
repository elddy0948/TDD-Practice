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

