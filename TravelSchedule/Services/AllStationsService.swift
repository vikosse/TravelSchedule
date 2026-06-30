//
//  AllStationsService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 29/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: BaseService, AllStationsServiceProtocol {

    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))

        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)

        return try JSONDecoder().decode(AllStations.self, from: fullData)
    }
}
