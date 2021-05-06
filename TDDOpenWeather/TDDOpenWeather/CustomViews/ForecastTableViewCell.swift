import UIKit

class ForecastTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ForecastTableViewCell.self)
    
    private let forecastView = ForecastCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configure() {
        contentView.addSubview(forecastView)
        NSLayoutConstraint.activate([
            forecastView.topAnchor.constraint(equalTo: topAnchor),
            forecastView.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
