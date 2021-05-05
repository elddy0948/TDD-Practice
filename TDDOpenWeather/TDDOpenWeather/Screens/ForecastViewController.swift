import UIKit

class ForecastViewController: UIViewController {
    var city: String?
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = city
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemYellow
    }
}
