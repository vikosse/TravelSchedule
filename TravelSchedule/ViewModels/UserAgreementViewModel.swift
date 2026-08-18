//
//  UserAgreementViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class UserAgreementViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var isLoading = true

    // MARK: - Dependencies

    let webViewLoader = WebViewLoader()

    // MARK: - Private properties

    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer")!

    // MARK: - Public methods

    func load() async {
        isLoading = true
        try? await webViewLoader.load(url: agreementURL)
        isLoading = false
    }
}
