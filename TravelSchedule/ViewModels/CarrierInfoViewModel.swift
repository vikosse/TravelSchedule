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
    private let service: CarrierInfoServiceProtocol

    // MARK: - Initializer

    init(
        carrierCode: String,
        service: CarrierInfoServiceProtocol = NetworkClient.shared
    ) {
        self.carrierCode = carrierCode
        self.service = service
    }

    // MARK: - Public methods

    func load() async {
        state = .loading

        do {
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
}
