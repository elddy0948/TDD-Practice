import UIKit

class ForecastTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ForecastTableViewCell.self)
    
    private var forecastView = ForecastCellView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        forecastView.clearAllViews()
    }
    
    private func configure() {
        contentView.addSubview(forecastView)
        selectionStyle = .none
        NSLayoutConstraint.activate([
            forecastView.topAnchor.constraint(equalTo: contentView.topAnchor),
            forecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureData(with forecast: Forecast) {
        forecastView.configureData(with: forecast)
    }
}
