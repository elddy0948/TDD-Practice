import UIKit

class CarImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CarImageCollectionViewCell.self)
    @IBOutlet weak var carImageView: UIImageView!
    
    func downloadImage(url: URL, type: FetchType) {
        switch type {
        case .normal:
            NetworkManager.shared.fetchImage(with: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.carImageView.image = image
                }
            }
        case .semaphore:
            NetworkManager.shared.fetchImageByTwo(with: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.carImageView.image = image
                }
            }
        }
    }
}
