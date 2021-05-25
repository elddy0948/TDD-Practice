import UIKit

class SearchCityView: UIView {
    
    //MARK: - ViewComponents
    private let searchCityStackView = UIStackView()
    private(set) var titleLabel = UILabel()
    private(set) var logoImageView = UIImageView()
    private(set) var cityTextField = OpenWeatherTextField()
    private(set) var searchButton = OpenWeatherButton(title: "Get current weather!", color: .systemOrange)
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Views
    private func configureStackView() {
        addSubview(searchCityStackView)
        configureViews()
        searchCityStackView.axis = .vertical
        searchCityStackView.distribution = .fill
        searchCityStackView.spacing = 30
        searchCityStackView.translatesAutoresizingMaskIntoConstraints = false
        searchCityStackView.addArrangedSubviews(views: titleLabel, logoImageView, cityTextField, searchButton)
        
        NSLayoutConstraint.activate([
            searchCityStackView.topAnchor.constraint(equalTo: topAnchor),
            searchCityStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchCityStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchCityStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureViews() {
        configureTitleLabel()
        configureLogoImageView()
        configureCityTextField()
        configureSearchButton()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "City Weather"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .systemOrange
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "sun")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func configureCityTextField() {
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
