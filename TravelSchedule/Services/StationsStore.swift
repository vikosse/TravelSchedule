//
//  StationsStore.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class StationsStore: ObservableObject {

    @Published private(set) var cities: [City] = []
    @Published private(set) var isLoading = false
    @Published private(set) var networkErrorKind: NetworkErrorKind?

    private let service: StationsCatalogServiceProtocol
    private var hasLoadedOnce = false

    init(service: StationsCatalogServiceProtocol = StationsCatalogService()) {
        self.service = service
    }

    func loadIfNeeded() async {
        guard !hasLoadedOnce, !isLoading else { return }
        await load()
    }

    func reload() async {
        await load()
    }

    private func load() async {
        isLoading = true
        networkErrorKind = nil

        do {
            let client = try APIClientFactory.makeClient()
            cities = try await service.fetchCities(client: client)
            hasLoadedOnce = true
        } catch {
            networkErrorKind = NetworkErrorClassifier.classify(error)
        }

        isLoading = false
    }
}
