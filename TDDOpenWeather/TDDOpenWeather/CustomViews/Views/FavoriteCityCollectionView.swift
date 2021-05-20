import UIKit

class FavoriteCityCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .systemBackground
        layer.masksToBounds = true
        collectionViewLayout = configureLayout()
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 10
        let flowLayout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds.width
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: screenSize - (2 * padding), height: 104)
        return flowLayout
    }
}
