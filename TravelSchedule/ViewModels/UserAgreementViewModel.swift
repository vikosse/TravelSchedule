//
//  UserAgreementViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

enum UserAgreementState {
    case loading
    case loaded
    case failure(NetworkErrorKind)
}

@MainActor
final class UserAgreementViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var state: UserAgreementState = .loading

    // MARK: - Dependencies

    let webViewLoader = WebViewLoader()

    // MARK: - Private properties

    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer")!

    // MARK: - Public methods

    func load() async {
        state = .loading
        do {
            try await webViewLoader.load(url: agreementURL)
            state = .loaded
        } catch {
            state = .failure(NetworkErrorClassifier.classify(error))
        }
    }
}
