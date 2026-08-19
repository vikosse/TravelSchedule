//
//  City.swift
//  TravelSchedule
//

import Foundation

struct City: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let stations: [Station]
}
