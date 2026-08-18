//
//  TravelRoute.swift
//  TravelSchedule
//

import Foundation

struct TravelRoute: Hashable, Sendable {
    let fromCity: City
    let fromStation: Station
    let toCity: City
    let toStation: Station
}
