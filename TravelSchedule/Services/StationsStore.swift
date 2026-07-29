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
    @Published private(set) var errorMessage: String?

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
        errorMessage = nil

        do {
            let client = try APIClientFactory.makeClient()
            cities = try await service.fetchCities(client: client)
            hasLoadedOnce = true
        } catch {
            errorMessage = "Не удалось загрузить список городов. Проверьте подключение к интернету и попробуйте ещё раз."
        }

        isLoading = false
    }
}
