//
//  MainScreenViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

enum RouteField {
    case from
    case to
}

@MainActor
final class MainScreenViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var fromCity: City?
    @Published private(set) var fromStation: Station?
    @Published private(set) var toCity: City?
    @Published private(set) var toStation: Station?

    @Published var isPickerPresented = false
    @Published var isShowingCarrierList = false
    @Published private(set) var activeField: RouteField = .from

    // MARK: - Dependencies

    let stationsStore: StationsStore

    // MARK: - Private properties

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Computed properties

    var networkErrorKind: NetworkErrorKind? {
        guard case let .failure(kind) = stationsStore.state else { return nil }
        return kind
    }

    var fromText: String {
        routeText(city: fromCity, station: fromStation)
    }

    var toText: String {
        routeText(city: toCity, station: toStation)
    }

    var isSearchAvailable: Bool {
        fromStation != nil && toStation != nil
    }

    var route: TravelRoute? {
        guard let fromCity, let fromStation, let toCity, let toStation else { return nil }
        return TravelRoute(fromCity: fromCity, fromStation: fromStation, toCity: toCity, toStation: toStation)
    }

    // MARK: - Initializer

    init(stationsStore: StationsStore) {
        self.stationsStore = stationsStore

        stationsStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Public methods

    func presentPicker(for field: RouteField) {
        activeField = field
        isPickerPresented = true
    }

    func apply(city: City, station: Station) {
        switch activeField {
        case .from:
            fromCity = city
            fromStation = station
        case .to:
            toCity = city
            toStation = station
        }
        isPickerPresented = false
    }

    func swapFields() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }

    func find() {
        isShowingCarrierList = true
    }

    func loadStationsIfNeeded() async {
        await stationsStore.loadIfNeeded()
    }

    func retryLoadingStations() async {
        await stationsStore.reload()
    }

    // MARK: - Private methods

    private func routeText(city: City?, station: Station?) -> String {
        guard let city else { return "" }
        guard let station else { return city.name }
        return RouteNameFormatter.displayName(city: city, station: station)
    }
}
