//
//  ScheduleFormatter.swift
//  TravelSchedule
//

import Foundation

enum ScheduleFormatter {

    private static let genitiveMonths = [
        1: "января", 2: "февраля", 3: "марта", 4: "апреля",
        5: "мая", 6: "июня", 7: "июля", 8: "августа",
        9: "сентября", 10: "октября", 11: "ноября", 12: "декабря"
    ]

    static func date(from iso: String) -> String {
        let datePart = iso.prefix(10)
        let components = datePart.split(separator: "-")
        guard
            components.count == 3,
            let month = Int(components[1]),
            let day = Int(components[2]),
            let monthName = genitiveMonths[month]
        else { return "" }
        return "\(day) \(monthName)"
    }

    static func today() -> String {
        let components = Calendar.current.dateComponents([.day, .month], from: Date())
        guard let day = components.day, let month = components.month, let monthName = genitiveMonths[month] else {
            return ""
        }
        return "\(day) \(monthName)"
    }

    static func queryDateString(from date: Date = Date()) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else {
            return ""
        }
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    static func time(from iso: String) -> String {
        if let tIndex = iso.firstIndex(of: "T") {
            let start = iso.index(after: tIndex)
            guard iso.distance(from: start, to: iso.endIndex) >= 5 else { return "" }
            let end = iso.index(start, offsetBy: 5)
            return String(iso[start..<end])
        }
        guard iso.count >= 5 else { return "" }
        return String(iso.prefix(5))
    }

    static func duration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        guard minutes != 0 else { return "\(hours) \(pluralizedHours(hours))" }
        return "\(hours) ч \(minutes) мин"
    }

    private static func pluralizedHours(_ count: Int) -> String {
        let mod100 = count % 100
        let mod10 = count % 10

        if (11...14).contains(mod100) { return "часов" }

        switch mod10 {
        case 1: return "час"
        case 2, 3, 4: return "часа"
        default: return "часов"
        }
    }
}
