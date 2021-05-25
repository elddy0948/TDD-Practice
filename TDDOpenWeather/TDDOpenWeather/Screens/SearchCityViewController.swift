import UIKit

class SearchCityViewController: UIViewController {
    
    private(set) var searchCityView = SearchCityView()
    
    var city: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    private func configureView() {
        let padding: CGFloat = 12
        
        view.addSubview(searchCityView)
        NSLayoutConstraint.activate([
            searchCityView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchCityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchCityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
