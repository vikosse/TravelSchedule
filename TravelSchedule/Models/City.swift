//
//  City.swift
//  TravelSchedule
//

import Foundation

struct City: Identifiable, Hashable {
    let id: String
    let name: String
    let stations: [Station]
}
