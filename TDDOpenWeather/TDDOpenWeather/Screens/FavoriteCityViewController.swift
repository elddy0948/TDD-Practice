import UIKit

class FavoriteCityViewController: UIViewController {
    
    //MARK: - Views
    private let favoriteCityCollectionView = FavoriteCityCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    //MARK: - Properties
    private var favoriteCities: [FavoriteCity] = []
    private let coreDataManager = CoreDataManager.shared

    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFavoriteCities()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Configure Views
    private func configure() {
        title = "Favorites"
        view.backgroundColor = .systemBackground
        view.addSubview(favoriteCityCollectionView)
        favoriteCityCollectionView.frame = view.bounds
        favoriteCityCollectionView.register(FavoriteCityCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCityCollectionViewCell.reuseIdentifier)
        favoriteCityCollectionView.delegate = self
        favoriteCityCollectionView.dataSource = self
    }
    
    private func configureFavoriteCities() {
        guard let data = coreDataManager.loadSavedData() else {
            return
        }
        favoriteCities = data
        favoriteCityCollectionView.reloadData()
    }
}

//MARK: - CollectionViewDataSource
extension FavoriteCityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCityCollectionViewCell.reuseIdentifier, for: indexPath) as? FavoriteCityCollectionViewCell else {
            return UICollectionViewCell()
        }
        let city = favoriteCities[indexPath.item]
        cell.configureBackgroundImage(city: city.name)
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension FavoriteCityViewController: UICollectionViewDelegate {
    
}
