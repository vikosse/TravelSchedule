//
//  StationsStore.swift
//  TravelSchedule
//

import Foundation
import Observation
import OpenAPIRuntime
import OpenAPIURLSession

@Observable
final class StationsStore {

    private(set) var cities: [City] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private var hasLoadedOnce = false

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
            let client = try Self.makeClient()
            cities = try await StationsCatalogService.fetchCities(client: client)
            hasLoadedOnce = true
        } catch {
            errorMessage = "Не удалось загрузить список городов. Проверьте подключение к интернету и попробуйте ещё раз."
        }

        isLoading = false
    }

    private static func makeClient() throws -> Client {
        Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: Constants.apiKey)]
        )
    }
}
