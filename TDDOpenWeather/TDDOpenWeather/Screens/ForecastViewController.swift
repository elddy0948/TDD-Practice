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
        navigationController?.navigationBar.isHidden = false
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

        guard let city = city else {
            return
        }
        
        networkManager.fetchForecastByCityName(city) { result in
            switch result {
            case .success(let forecastList):
                self.forecast = forecastList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
