//
//  ScheduleBetweenStationsService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> Segments
}

final class ScheduleBetweenStationsService: BaseService, ScheduleBetweenStationsServiceProtocol {

    func getScheduleBetweenStations(from: String, to: String, date: String? = nil) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))
        return try response.ok.body.json
    }
}
