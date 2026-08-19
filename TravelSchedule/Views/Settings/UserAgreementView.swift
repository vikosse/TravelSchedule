//
//  UserAgreementView.swift
//  TravelSchedule
//

import SwiftUI

struct UserAgreementView: View {

    // MARK: - Properties

    @StateObject private var viewModel = UserAgreementViewModel()
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        content
            .navigationTitle("Пользовательское соглашение")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: SystemImageName.backChevron)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.ypBlack)
                    }
                }
            }
            .task {
                await viewModel.load()
            }
    }

    // MARK: - Private views

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ZStack {
                WebView(webView: viewModel.webViewLoader.webView)
                    .ignoresSafeArea(edges: .bottom)

                ProgressView()
                    .tint(Color.ypBlue)
            }
        case .loaded:
            WebView(webView: viewModel.webViewLoader.webView)
                .ignoresSafeArea(edges: .bottom)
        case .failure(let networkErrorKind):
            NetworkErrorView(kind: networkErrorKind) {
                Task { await viewModel.load() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
