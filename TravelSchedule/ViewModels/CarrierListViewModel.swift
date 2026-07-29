//
//  CarrierListViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class CarrierListViewModel: ObservableObject {

    let fromCity: City
    let fromStation: Station
    let toCity: City
    let toStation: Station

    @Published private(set) var segments: [Segment] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    var routeTitle: String {
        "\(RouteNameFormatter.displayName(city: fromCity, station: fromStation)) → \(RouteNameFormatter.displayName(city: toCity, station: toStation))"
    }

    init(fromCity: City, fromStation: Station, toCity: City, toStation: Station) {
        self.fromCity = fromCity
        self.fromStation = fromStation
        self.toCity = toCity
        self.toStation = toStation
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let client = try APIClientFactory.makeClient()
            let service = ScheduleBetweenStationsService(client: client)
            let result = try await service.getScheduleBetweenStations(
                from: fromStation.id,
                to: toStation.id,
                date: ScheduleFormatter.queryDateString()
            )
            segments = (result.segments ?? []).sorted { departureSortKey(for: $0) < departureSortKey(for: $1) }
        } catch {
            errorMessage = "Не удалось загрузить список перевозчиков. Проверьте подключение к интернету и попробуйте ещё раз."
        }

        isLoading = false
    }

    private func departureSortKey(for segment: Segment) -> String {
        let datePart = segment.start_date ?? ""
        let timePart = segment.departure ?? segment.thread?.interval?.begin_time ?? ""
        return datePart + timePart
    }
}
