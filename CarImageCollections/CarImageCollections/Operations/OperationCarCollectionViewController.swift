import UIKit

private let reuseIdentifier = "Cell"

class OperationCarCollectionViewController: UICollectionViewController {
    private let queue = OperationQueue()
    private var urls = [URL]()
    private var operations = [IndexPath: Operation]()
    private let cellSpacing: CGFloat = 1
    
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
        urls = serialUrls.compactMap { URL(string: $0) }
    }
}


//MARK: - DataSource
extension OperationCarCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarImageCollectionViewCell.reuseIdentifier, for: indexPath) as? CarImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setImage(with: UIImage(systemName: "car.fill")!)
        let downloadOperation = CarImageOperation(url: urls[indexPath.item])
        downloadOperation.completionBlock = {
            DispatchQueue.main.async {
                var cell = collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell
                if cell == nil {
                    collectionView.reloadData()
                    collectionView.layoutIfNeeded()
                    cell = collectionView.cellForItem(at: indexPath) as? CarImageCollectionViewCell
                }
                cell?.setImage(with: downloadOperation.image!)
            }
        }
        queue.addOperation(downloadOperation)
        
        if let existingOperations = operations[indexPath] {
            existingOperations.cancel()
        }
        operations[indexPath] = downloadOperation
        return cell
    }
}

extension OperationCarCollectionViewController: UICollectionViewDelegateFlowLayout {
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
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let operation = operations[indexPath] {
            operation.cancel()
        }
    }
}
