import UIKit


extension Date {
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: self)
        return localDate
    }
}

extension Double {
    func convertTemperature(from: UnitTemperature, to: UnitTemperature) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: from)
        let output = input.converted(to: to)
        return measurementFormatter.string(from: output)
    }
}

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}
