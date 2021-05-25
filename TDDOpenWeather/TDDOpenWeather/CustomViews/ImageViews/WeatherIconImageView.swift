import UIKit

class WeatherIconImageView: UIImageView {
    private let placeholder = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        image = placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fetchImage(imageName: String) {
        NetworkManager.shared.fetchImage(with: imageName) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
