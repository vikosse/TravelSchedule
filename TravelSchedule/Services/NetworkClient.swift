//
//  NetworkClient.swift
//  TravelSchedule
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkClient {

    static let shared = NetworkClient()

    private var client: Client?

    init() {}

    private func resolveClient() throws -> Client {
        if let client { return client }
        let client = try APIClientFactory.makeClient()
        self.client = client
        return client
    }
}

extension NetworkClient: AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations {
        let client = try resolveClient()
        let fullData = try await AllStationsRawDataFetcher.fetchData(client: client)
        return try JSONDecoder().decode(AllStations.self, from: fullData)
    }
}

extension NetworkClient: CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        let client = try resolveClient()
        let response = try await client.getCarrierInfo(query: .init(
            code: code
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightInfo {
        let client = try resolveClient()
        let response = try await client.getCopyright(query: .init())
        return try response.ok.body.json
    }
}

extension NetworkClient: NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        let client = try resolveClient()
        let response = try await client.getNearestCity(query: .init(
            lat: lat,
            lng: lng
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let client = try resolveClient()
        let response = try await client.getNearestStations(query: .init(
            lat: lat,
            lng: lng,
            distance: distance
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: RouteStationsServiceProtocol {
    func getRouteStations(uid: String, date: String? = nil) async throws -> ThreadStations {
        let client = try resolveClient()
        let response = try await client.getRouteStations(query: .init(
            uid: uid,
            date: date
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String, date: String? = nil, transfers: Bool? = nil) async throws -> Segments {
        let client = try resolveClient()
        let response = try await client.getSchedualBetweenStations(query: .init(
            from: from,
            to: to,
            date: date,
            transfers: transfers
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: StationScheduleServiceProtocol {
    func getStationSchedule(station: String, date: String? = nil) async throws -> StationSchedule {
        let client = try resolveClient()
        let response = try await client.getStationSchedule(query: .init(
            station: station,
            date: date
        ))
        return try response.ok.body.json
    }
}

extension NetworkClient: StationsCatalogServiceProtocol {
    func fetchCities() async throws -> [City] {
        let client = try resolveClient()
        let fullData = try await AllStationsRawDataFetcher.fetchData(client: client)
        return try StationsCatalogMapper.mapCities(from: fullData)
    }
}
