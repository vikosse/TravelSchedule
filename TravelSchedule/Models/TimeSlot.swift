//
//  TimeSlot.swift
//  TravelSchedule
//

import Foundation

enum TimeSlot: CaseIterable, Hashable {
    case morning
    case day
    case evening
    case night

    var title: String {
        switch self {
        case .morning: return "Утро 06:00 - 12:00"
        case .day: return "День 12:00 - 18:00"
        case .evening: return "Вечер 18:00 - 00:00"
        case .night: return "Ночь 00:00 - 06:00"
        }
    }

    var hourRange: Range<Int> {
        switch self {
        case .morning: return 6..<12
        case .day: return 12..<18
        case .evening: return 18..<24
        case .night: return 0..<6
        }
    }
}
