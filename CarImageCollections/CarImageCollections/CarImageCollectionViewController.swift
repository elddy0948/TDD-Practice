import UIKit

class CarImageCollectionViewController: UICollectionViewController {
    private(set) var carImageUrls = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUrls()
    }
    
    private func configureUrls() {
        guard let plist = Bundle.main.url(forResource: "CarImages", withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String] else {
          print("이미지 URL을 가져오지 못했습니다")
          return
        }
        carImageUrls = serialUrls.compactMap { URL(string: $0) }
    }
}
