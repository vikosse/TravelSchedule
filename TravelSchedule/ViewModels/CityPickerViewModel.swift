//
//  CityPickerViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class CityPickerViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var searchText = ""
    @Published private(set) var filteredCities: [City] = []

    // MARK: - Private properties

    private let store: StationsStore
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Computed properties

    var state: StationsStoreState {
        store.state
    }

    // MARK: - Initializer

    init(store: StationsStore) {
        self.store = store

        store.$state
            .combineLatest(
                $searchText
                    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                    .prepend(searchText)
            )
            .map { state, query in
                guard case let .success(cities) = state else { return [] }
                return SearchFilter.apply(cities, query: query, keyPath: \.name)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$filteredCities)

        store.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Public methods

    func loadIfNeeded() async {
        await store.loadIfNeeded()
    }

    func reload() async {
        await store.reload()
    }
}
