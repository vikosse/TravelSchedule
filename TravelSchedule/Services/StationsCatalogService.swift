//
//  StationsCatalogService.swift
//  TravelSchedule
//

import Foundation

protocol StationsCatalogServiceProtocol {
    func fetchCities() async throws -> [City]
}

enum StationsCatalogMapper {

    static func mapCities(from data: Data) throws -> [City] {
        let payload = try JSONDecoder().decode(CatalogPayload.self, from: data)
        return mapCities(from: payload)
    }

    private static func mapCities(from payload: CatalogPayload) -> [City] {
        let russia = payload.countries?.first { $0.title == "Россия" }
        let settlements = (russia?.regions ?? []).flatMap { $0.settlements ?? [] }

        let cities: [City] = settlements.compactMap { settlement in
            guard
                let cityName = settlement.title,
                let cityCode = settlement.codes?.yandexCode
            else { return nil }

            let stations: [Station] = (settlement.stations ?? []).compactMap { station in
                guard
                    let stationName = nonEmpty(station.shortTitle) ?? nonEmpty(station.title),
                    let stationCode = station.codes?.yandexCode
                else { return nil }
                return Station(id: stationCode, name: stationName)
            }

            guard !stations.isEmpty else { return nil }
            return City(id: cityCode, name: cityName, stations: stations)
        }

        return cities.sorted { lhs, rhs in
            if lhs.stations.count != rhs.stations.count {
                return lhs.stations.count > rhs.stations.count
            }
            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
    }

    private static func nonEmpty(_ value: String?) -> String? {
        guard let value, !value.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        return value
    }

    private struct CatalogPayload: Decodable {
        let countries: [CountryPayload]?
    }

    private struct CountryPayload: Decodable {
        let title: String?
        let regions: [RegionPayload]?
    }

    private struct RegionPayload: Decodable {
        let title: String?
        let settlements: [SettlementPayload]?
    }

    private struct SettlementPayload: Decodable {
        let title: String?
        let codes: CodesPayload?
        let stations: [StationPayload]?
    }

    private struct StationPayload: Decodable {
        let title: String?
        let shortTitle: String?
        let codes: CodesPayload?

        enum CodingKeys: String, CodingKey {
            case title
            case shortTitle = "short_title"
            case codes
        }
    }

    private struct CodesPayload: Decodable {
        let yandexCode: String?

        enum CodingKeys: String, CodingKey {
            case yandexCode = "yandex_code"
        }
    }
}
