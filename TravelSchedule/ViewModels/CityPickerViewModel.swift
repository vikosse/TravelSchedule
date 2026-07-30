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
    var networkErrorKind: NetworkErrorKind? { store.networkErrorKind }

    init(store: StationsStore) {
        self.store = store
        self.filteredCities = store.cities

        store.$cities
            .combineLatest($searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main))
            .map { cities, query in SearchFilter.apply(cities, query: query, keyPath: \.name) }
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
