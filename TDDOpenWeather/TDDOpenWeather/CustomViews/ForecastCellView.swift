import UIKit

class ForecastCellView: UIView {
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let timeDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private let weatherIcon = WeatherIconImageView(frame: .zero)
    
    private let tempMaxMinStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private let tempMaxLabel = TempLabel(font: UIFont.preferredFont(forTextStyle: .body))
    
    private let tempMinLabel = TempLabel(font: UIFont.preferredFont(forTextStyle: .body))
    
    private let tempLabel = TempLabel(font: UIFont.preferredFont(forTextStyle: .title1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(cellStackView)
        translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(timeDataLabel)
        cellStackView.addArrangedSubview(weatherIcon)
        cellStackView.addArrangedSubview(tempMaxMinStackView)
        cellStackView.addArrangedSubview(tempLabel)
        
        tempMaxMinStackView.addArrangedSubview(tempMaxLabel)
        tempMaxMinStackView.addArrangedSubview(tempMinLabel)
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureData(with forecast: Forecast) {
        let date = Date(timeIntervalSince1970: forecast.dt).getLocalDate()
        timeDataLabel.text = date
        tempMaxLabel.text = "\(forecast.main.tempMax.convertTemperature(from: .kelvin, to: .celsius))"
        tempMinLabel.text = "\(forecast.main.tempMin.convertTemperature(from: .kelvin, to: .celsius))"
        tempLabel.text = "\(forecast.main.temp.convertTemperature(from: .kelvin, to: .celsius))"
        weatherIcon.fetchImage(imageName: forecast.weather[0].icon)
    }
    
    func clearAllViews() {
        timeDataLabel.text = nil
        tempMaxLabel.text = nil
        tempMinLabel.text = nil
        tempLabel.text = nil
        weatherIcon.image = nil
    }
}
