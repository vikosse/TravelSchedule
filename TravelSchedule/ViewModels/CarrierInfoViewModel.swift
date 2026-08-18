//
//  CarrierInfoViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

enum CarrierInfoState {
    case loading
    case success(Carrier)
    case failure(NetworkErrorKind)
}

@MainActor
final class CarrierInfoViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var state: CarrierInfoState = .loading

    // MARK: - Private properties

    private let carrierCode: String
    private var service: CarrierInfoServiceProtocol?

    // MARK: - Initializer

    init(
        carrierCode: String,
        service: CarrierInfoServiceProtocol? = nil
    ) {
        self.carrierCode = carrierCode
        self.service = service
    }

    // MARK: - Public methods

    func load() async {
        state = .loading

        do {
            let service = try resolveService()
            let response = try await service.getCarrierInfo(code: carrierCode)

            guard let carrier = response.carrier else {
                state = .failure(.serverError)
                return
            }
            state = .success(carrier)
        } catch {
            state = .failure(NetworkErrorClassifier.classify(error))
        }
    }

    // MARK: - Private methods

    private func resolveService() throws -> CarrierInfoServiceProtocol {
        if let service { return service }
        let client = try APIClientFactory.makeClient()
        let service = CarrierInfoService(client: client)
        self.service = service
        return service
    }
}
