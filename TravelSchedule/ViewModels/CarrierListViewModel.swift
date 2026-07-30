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
    @Published private(set) var networkErrorKind: NetworkErrorKind?

    @Published private(set) var selectedTimeSlots: Set<TimeSlot> = []
    @Published private(set) var transfersOption: TransfersOption?
    @Published var isShowingFilters = false

    var routeTitle: String {
        "\(RouteNameFormatter.displayName(city: fromCity, station: fromStation)) → \(RouteNameFormatter.displayName(city: toCity, station: toStation))"
    }

    var filteredSegments: [Segment] {
        segments.filter { matchesTimeSlots($0) && matchesTransfersOption($0) }
    }

    var rowViewModels: [CarrierRowViewModel] {
        let fallbackDate = ScheduleFormatter.today()
        return filteredSegments.map { CarrierRowViewModel(segment: $0, fallbackDate: fallbackDate) }
    }

    var hasActiveFilters: Bool {
        !selectedTimeSlots.isEmpty || transfersOption != nil
    }

    init(fromCity: City, fromStation: Station, toCity: City, toStation: Station) {
        self.fromCity = fromCity
        self.fromStation = fromStation
        self.toCity = toCity
        self.toStation = toStation
    }

    func load() async {
        isLoading = true
        networkErrorKind = nil

        do {
            let client = try APIClientFactory.makeClient()
            let service = ScheduleBetweenStationsService(client: client)
            let result = try await service.getScheduleBetweenStations(
                from: fromStation.id,
                to: toStation.id,
                date: ScheduleFormatter.queryDateString(),
                transfers: true
            )
            segments = (result.segments ?? []).sorted { departureSortKey(for: $0) < departureSortKey(for: $1) }
        } catch {
            networkErrorKind = NetworkErrorClassifier.classify(error)
        }

        isLoading = false
    }

    private func departureSortKey(for segment: Segment) -> String {
        let datePart = segment.start_date ?? ""
        let timePart = segment.departure ?? segment.thread?.interval?.begin_time ?? ""
        return datePart + timePart
    }

    private func departureHour(for segment: Segment) -> Int? {
        let rawTime = segment.departure ?? segment.thread?.interval?.begin_time
        guard let rawTime else { return nil }
        return Int(ScheduleFormatter.time(from: rawTime).prefix(2))
    }

    private func matchesTimeSlots(_ segment: Segment) -> Bool {
        guard !selectedTimeSlots.isEmpty else { return true }
        guard let hour = departureHour(for: segment) else { return true }
        return selectedTimeSlots.contains { $0.hourRange.contains(hour) }
    }

    private func matchesTransfersOption(_ segment: Segment) -> Bool {
        guard let transfersOption else { return true }
        guard let hasTransfers = segment.has_transfers else { return true }
        switch transfersOption {
        case .yes: return hasTransfers
        case .no: return !hasTransfers
        }
    }

    func showFilters() {
        isShowingFilters = true
    }

    func applyFilters(timeSlots: Set<TimeSlot>, transfersOption: TransfersOption?) {
        selectedTimeSlots = timeSlots
        self.transfersOption = transfersOption
    }
}
