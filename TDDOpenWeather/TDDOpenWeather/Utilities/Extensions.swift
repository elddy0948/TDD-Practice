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
