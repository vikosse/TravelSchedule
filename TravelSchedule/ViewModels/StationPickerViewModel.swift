//
//  StationPickerViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class StationPickerViewModel: ObservableObject {

    let city: City

    @Published var searchText = ""
    @Published private(set) var filteredStations: [Station]

    init(city: City) {
        self.city = city
        self.filteredStations = city.stations

        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { query in
                guard !query.isEmpty else { return city.stations }
                return city.stations.filter { $0.name.localizedCaseInsensitiveContains(query) }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$filteredStations)
    }
}
