//
//  CityDeclensionFormatter.swift
//  TravelSchedule
//

import Foundation

enum CityDeclensionFormatter {

    static func prepositional(_ cityName: String) -> String {
        if cityName.hasSuffix("ия") {
            return String(cityName.dropLast(2)) + "ии"
        }
        if cityName.hasSuffix("а") || cityName.hasSuffix("я") {
            return String(cityName.dropLast(1)) + "е"
        }
        if cityName.hasSuffix("ь") {
            return String(cityName.dropLast(1)) + "и"
        }
        if let last = cityName.last, !"оеыи".contains(last) {
            return cityName + "е"
        }
        return cityName
    }
}
