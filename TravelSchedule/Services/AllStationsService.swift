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
        let fullData = try await AllStationsRawDataFetcher.fetchData(client: client)
        return try JSONDecoder().decode(AllStations.self, from: fullData)
    }
}
