import UIKit

class ForecastViewController: UIViewController {
    var city: String?
    var forecast: [Forecast] = []
    var coreDataManager: CoreDataManager!
    var favorites = [FavoriteCity]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoreData()
        configure()
        fetchCityForecast()
        configureTableView()
    }
    
    private func configureCoreData() {
        coreDataManager = CoreDataManager.shared
        guard let favoriteCity = coreDataManager.loadSavedData() else {
            return
        }
        favorites = favoriteCity
    }
    
    private func configure() {
        title = city
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        if favorites.contains(where: { $0.name == city }) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(didTappedFavoriteButton(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(didTappedFavoriteButton(_:)))
        }
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
    
    func findCityAndDelete() {
        let filteredFavorites = favorites.filter { $0.name == city }
        if !filteredFavorites.isEmpty {
            coreDataManager.delete(object: filteredFavorites[0])
        }
    }
    
    @objc func didTappedFavoriteButton(_ sender: UIBarButtonItem) {
        let currentImage = sender.image!
        if currentImage == UIImage(systemName: "star") {
            sender.image = UIImage(systemName: "star.fill")!
            coreDataManager.insertCity(city: self.city!)
        } else {
            sender.image = UIImage(systemName: "star")!
            findCityAndDelete()
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
