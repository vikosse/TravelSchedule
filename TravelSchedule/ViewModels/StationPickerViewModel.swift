//
//  StationPickerViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class StationPickerViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var searchText = ""
    @Published private(set) var filteredStations: [Station]

    // MARK: - Dependencies

    let city: City

    // MARK: - Initializer

    init(city: City) {
        self.city = city
        self.filteredStations = city.stations

        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { query in SearchFilter.apply(city.stations, query: query, keyPath: \.name) }
            .receive(on: RunLoop.main)
            .assign(to: &$filteredStations)
    }
}
