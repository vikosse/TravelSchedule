//
//  RouteStationsService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import OpenAPIRuntime

typealias ThreadStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String, date: String?) async throws -> ThreadStations
}
