import UIKit

class CarImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CarImageCollectionViewCell.self)
    @IBOutlet weak var carImageView: UIImageView!
    
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
}
