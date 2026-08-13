//
//  UserAgreementView.swift
//  TravelSchedule
//

import SwiftUI

struct UserAgreementView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true

    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer")!

    // MARK: - Body

    var body: some View {
        ZStack {
            WebView(url: agreementURL, isLoading: $isLoading)
                .ignoresSafeArea(edges: .bottom)

            if isLoading {
                ProgressView()
                    .tint(Color.ypBlue)
            }
        }
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.ypBlack)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
