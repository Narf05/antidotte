import Foundation

extension Date {
    var isNightTime: Bool {
        let hour = Calendar.current.component(.hour, from: self)
        return hour >= 20 || hour < 6
    }

    var nightBucketStart: Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        let hour = calendar.component(.hour, from: self)

        if hour < 6 {
            return calendar.date(byAdding: .day, value: -1, to: startOfDay) ?? startOfDay
        }

        return startOfDay
    }

    var responsibilityWindowEnd: Date {
        addingTimeInterval(12 * 60 * 60)
    }

    var shortTimeString: String {
        formatted(date: .omitted, time: .shortened)
    }

    var shortDateString: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var shortDateTimeString: String {
        formatted(date: .abbreviated, time: .shortened)
    }

    func hoursAgo(_ hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: -hours, to: self) ?? self
    }

    func addingHours(_ hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }

    func minutesSince(_ date: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    func isWithinLast(hours: Int, from now: Date = Date()) -> Bool {
        self >= now.hoursAgo(hours)
    }
}
