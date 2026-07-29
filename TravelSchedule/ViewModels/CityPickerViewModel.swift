//
//  CityPickerViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class CityPickerViewModel: ObservableObject {

    @Published var searchText = ""
    @Published private(set) var filteredCities: [City]

    private let store: StationsStore
    private var cancellables: Set<AnyCancellable> = []

    var isLoading: Bool { store.isLoading }
    var errorMessage: String? { store.errorMessage }

    init(store: StationsStore) {
        self.store = store
        self.filteredCities = store.cities

        store.$cities
            .combineLatest($searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main))
            .map { cities, query in
                guard !query.isEmpty else { return cities }
                return cities.filter { $0.name.localizedCaseInsensitiveContains(query) }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$filteredCities)

        store.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    func loadIfNeeded() async {
        await store.loadIfNeeded()
    }

    func reload() async {
        await store.reload()
    }
}
