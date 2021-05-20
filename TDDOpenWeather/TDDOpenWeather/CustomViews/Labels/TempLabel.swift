import UIKit

class TempLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(font: UIFont.preferredFont(forTextStyle: .body))
    }
    
    init(font: UIFont) {
        super.init(frame: .zero)
        configure(font: font)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(font: UIFont) {
        textColor = .label
        textAlignment = .center
        self.font = font
    }
}
