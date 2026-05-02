import Foundation

extension Date {
    var isNightTime: Bool {
        let hour = Calendar.current.component(.hour, from: self)
        return hour >= 20 || hour < 6
    }

    func hoursAgo(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: -hours, to: self) ?? self
    }
}
