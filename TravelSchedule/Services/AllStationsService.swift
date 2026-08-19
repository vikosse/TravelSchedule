//
//  AllStationsService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 29/06/2026.
//

import OpenAPIRuntime

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}
