import UIKit

class FavoriteCityViewController: UIViewController {
    private var favoriteCities: [FavoriteCity] = []
    private let coreDataManager = CoreDataManager.shared
    private let favoriteCityCollectionView = FavoriteCityCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFavoriteCities()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
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

extension FavoriteCityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCityCollectionViewCell.reuseIdentifier, for: indexPath) as? FavoriteCityCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .yellow
        return cell
    }
}
extension FavoriteCityViewController: UICollectionViewDelegate {
    
}
