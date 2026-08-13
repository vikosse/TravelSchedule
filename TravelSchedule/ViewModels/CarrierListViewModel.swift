//
//  CarrierListViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

enum CarrierListState {
    case loading
    case success([Segment])
    case failure(NetworkErrorKind)
}

@MainActor
final class CarrierListViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var state: CarrierListState = .loading
    @Published private(set) var selectedTimeSlots: Set<TimeSlot> = []
    @Published private(set) var transfersOption: TransfersOption?

    // MARK: - Private properties

    private let route: TravelRoute
    private let service: ScheduleBetweenStationsServiceProtocol
    private var hasLoadedOnce = false

    // MARK: - Computed properties

    var routeTitle: String {
        let from = RouteNameFormatter.displayName(city: route.fromCity, station: route.fromStation)
        let to = RouteNameFormatter.displayName(city: route.toCity, station: route.toStation)
        return "\(from) → \(to)"
    }

    var filteredSegments: [Segment] {
        guard case let .success(segments) = state else { return [] }
        return segments.filter { matchesTimeSlots($0) && matchesTransfersOption($0) }
    }

    var rowViewModels: [CarrierRowViewModel] {
        let fallbackDate = ScheduleFormatter.today()
        return filteredSegments.enumerated().map { index, segment in
            CarrierRowViewModel(segment: segment, fallbackDate: fallbackDate, index: index)
        }
    }

    var hasActiveFilters: Bool {
        !selectedTimeSlots.isEmpty || transfersOption != nil
    }

    var hasSegments: Bool {
        guard case let .success(segments) = state else { return false }
        return !segments.isEmpty
    }

    // MARK: - Initializer

    init(
        route: TravelRoute,
        service: ScheduleBetweenStationsServiceProtocol = ScheduleBetweenStationsService(client: try! APIClientFactory.makeClient())
    ) {
        self.route = route
        self.service = service
    }

    // MARK: - Public methods

    func loadIfNeeded() async {
        guard !hasLoadedOnce else { return }
        await load()
    }

    func load() async {
        state = .loading

        do {
            let result = try await service.getScheduleBetweenStations(
                from: route.fromStation.id,
                to: route.toStation.id,
                date: ScheduleFormatter.queryDateString(),
                transfers: true
            )
            let segments = (result.segments ?? []).sorted { departureSortKey(for: $0) < departureSortKey(for: $1) }
            hasLoadedOnce = true
            state = .success(segments)
        } catch {
            state = .failure(NetworkErrorClassifier.classify(error))
        }
    }

    func applyFilters(timeSlots: Set<TimeSlot>, transfersOption: TransfersOption?) {
        selectedTimeSlots = timeSlots
        self.transfersOption = transfersOption
    }

    // MARK: - Private methods

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
}
