import UIKit

class SearchCityViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let cityTextField = OpenWeatherTextField()
    let searchButton = OpenWeatherButton(title: "Get current weather!", color: .systemOrange)
    var city: String = "enter"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureButton()
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "sun")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(cityTextField)
        
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            cityTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(didTappedSearchButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didTappedSearchButton(_ sender: UIButton) {
        city = cityTextField.text ?? ""
    }
}

