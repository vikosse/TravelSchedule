//
//  TransfersOption.swift
//  TravelSchedule
//

import Foundation

enum TransfersOption: CaseIterable, Hashable {
    case yes
    case no

    var title: String {
        switch self {
        case .yes: return "Да"
        case .no: return "Нет"
        }
    }
}
