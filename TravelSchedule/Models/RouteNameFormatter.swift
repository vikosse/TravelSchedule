//
//  RouteNameFormatter.swift
//  TravelSchedule
//

import Foundation

enum RouteNameFormatter {

    static func displayName(city: City, station: Station) -> String {
        let prefix = "\(city.name) ("
        if station.name.hasPrefix(prefix) {
            return station.name
        }
        return "\(city.name) (\(station.name))"
    }
}
