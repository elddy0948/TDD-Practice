import UIKit

class DownloadByTwoCollectionViewController: UICollectionViewController {
    private(set) var carImageUrls = [URL]()
    private let cellSpacing: CGFloat = 1
    private let dispatchQueue = DispatchQueue(label: "downloadByTwoCollection", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUrls()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let nib = UINib(nibName: CarImageCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CarImageCollectionViewCell.reuseIdentifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 10
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
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
    
    func convertURLToImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}

extension DownloadByTwoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carImageUrls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarImageCollectionViewCell.reuseIdentifier, for: indexPath) as? CarImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let url = carImageUrls[indexPath.item]
        dispatchQueue.async {
            cell.downloadImage(url: url, type: .semaphore)
        }
        return cell
    }
}

extension DownloadByTwoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGFloat = 0
        let columns: CGFloat = 2
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
        cellSize = (view.frame.size.width - emptySpace) / columns
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
