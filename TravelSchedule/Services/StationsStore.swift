//
//  StationsStore.swift
//  TravelSchedule
//

import Foundation
import Combine

enum StationsStoreState {
    case idle
    case loading
    case success([City])
    case failure(NetworkErrorKind)
}

@MainActor
final class StationsStore: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var state: StationsStoreState = .idle

    // MARK: - Private properties

    private let service: StationsCatalogServiceProtocol
    private var hasLoadedOnce = false

    // MARK: - Initializer

    init(service: StationsCatalogServiceProtocol = StationsCatalogService()) {
        self.service = service
    }

    // MARK: - Public methods

    func loadIfNeeded() async {
        guard !hasLoadedOnce else { return }
        if case .loading = state { return }
        await load()
    }

    func reload() async {
        await load()
    }

    // MARK: - Private methods

    private func load() async {
        state = .loading

        do {
            let client = try APIClientFactory.makeClient()
            let cities = try await service.fetchCities(client: client)
            hasLoadedOnce = true
            state = .success(cities)
        } catch {
            state = .failure(NetworkErrorClassifier.classify(error))
        }
    }
}
