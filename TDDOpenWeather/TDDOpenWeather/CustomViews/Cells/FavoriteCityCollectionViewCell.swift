import UIKit

class FavoriteCityCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FavoriteCityCollectionViewCell.self)
    
    private let cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(cityImageView)
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemGray
        cityImageView.frame = contentView.bounds
        configureCityNameLabel()
    }
    
    private func configureCityNameLabel() {
        cityImageView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.centerXAnchor.constraint(equalTo: cityImageView.centerXAnchor),
            cityNameLabel.centerYAnchor.constraint(equalTo: cityImageView.centerYAnchor)
        ])
    }
    
    func configureBackgroundImage(city: String?) {
        guard let city = city else { return }
        cityImageView.image = UIImage(named: "\(city.lowercased())-image")
        cityImageView.layer.cornerRadius = 12
        cityNameLabel.text = city
    }
}
