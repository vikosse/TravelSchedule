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

    let stationsStore: StationsStore

    @Published private(set) var fromCity: City?
    @Published private(set) var fromStation: Station?
    @Published private(set) var toCity: City?
    @Published private(set) var toStation: Station?

    @Published var isPickerPresented = false
    @Published var isShowingCarrierList = false
    @Published private(set) var activeField: RouteField = .from

    init(stationsStore: StationsStore) {
        self.stationsStore = stationsStore
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

    private func routeText(city: City?, station: Station?) -> String {
        guard let city else { return "" }
        guard let station else { return city.name }
        return RouteNameFormatter.displayName(city: city, station: station)
    }
}
