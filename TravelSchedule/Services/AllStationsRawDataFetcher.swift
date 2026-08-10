//
//  AllStationsRawDataFetcher.swift
//  TravelSchedule
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum AllStationsRawDataFetcher {

    static func fetchData(client: Client) async throws -> Data {
        let response = try await client.getAllStations(query: .init())
        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024
        return try await Data(collecting: responseBody, upTo: limit)
    }
}
