import UIKit

final class SearchCityViewController: UIViewController {
    
    //MARK: - Views
    private(set) var searchCityView = SearchCityView()
    
    //MARK: - Properties
    var city: String = ""
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    //MARK: - ConfigureViews
    private func configureView() {
        let padding: CGFloat = 12
        
        view.addSubview(searchCityView)
        searchCityView.delegate = self
        
        NSLayoutConstraint.activate([
            searchCityView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchCityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchCityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    //MARK: - Privates
    private func pushForecastViewController(with city: String) {
        let forecastViewController = ForecastViewController()
        forecastViewController.city = city
        navigationController?.pushViewController(forecastViewController, animated: true)
    }
}

//MARK: - SearchCityViewDelegate
extension SearchCityViewController: SearchCityViewDelegate {
    func searchButtonTapped(_ searchCityView: SearchCityView, with cityname: String?) {
        guard let cityname = cityname,
              !cityname.isEmpty else {
            presentAlertOnMainThread(title: "문제가 발생했어요!", message: "도시 이름을 다시 확인해주세요!", buttonTitle: "OK")
            return
        }
        pushForecastViewController(with: cityname)
    }
}
