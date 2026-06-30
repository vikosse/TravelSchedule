//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightInfo = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightInfo
}

final class CopyrightService: BaseService, CopyrightServiceProtocol {

    func getCopyright() async throws -> CopyrightInfo {
        let response = try await client.getCopyright(query: .init(apikey: apikey))
        return try response.ok.body.json
    }
}
