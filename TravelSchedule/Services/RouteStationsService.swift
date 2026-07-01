//
//  RouteStationsService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String, date: String?) async throws -> ThreadStations
}

final class RouteStationsService: BaseService, RouteStationsServiceProtocol {

    func getRouteStations(uid: String, date: String? = nil) async throws -> ThreadStations {
        let response = try await client.getRouteStations(query: .init(
            uid: uid,
            date: date
        ))
        return try response.ok.body.json
    }
}
