//
//  NearestCityService.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
}

final class NearestCityService: BaseService, NearestCityServiceProtocol {

    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(
            lat: lat,
            lng: lng
        ))
        return try response.ok.body.json
    }
}
