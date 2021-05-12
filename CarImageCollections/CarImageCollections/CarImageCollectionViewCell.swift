import UIKit

class CarImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CarImageCollectionViewCell.self)
    @IBOutlet weak var carImageView: UIImageView!
    
    func setImage(with image: UIImage) {
        carImageView.image = image
    }
}
