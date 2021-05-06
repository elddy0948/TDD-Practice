import UIKit

class ForecastViewController: UIViewController {
    var city: String?
    var forecast: [Forecast] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchCityForecast()
        configureTableView()
    }
    
    private func configure() {
        title = city
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchCityForecast() {
        let networkManager = NetworkManager.shared

        guard let city = city,
              let forecastList = networkManager.fetchMockData(cityName: city) else {
            return
        }
        
        forecast = forecastList
    }
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        cell.configureData(with: forecast[indexPath.row])
        return cell
    }
}
