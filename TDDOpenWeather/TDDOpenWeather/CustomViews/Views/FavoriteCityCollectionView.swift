import UIKit

class FavoriteCityCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .systemBackground
        collectionViewLayout = configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds.width
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: screenSize, height: 104)
        return flowLayout
    }
}
