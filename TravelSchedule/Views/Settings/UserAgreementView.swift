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
        ZStack {
            WebView(webView: viewModel.webViewLoader.webView)
                .ignoresSafeArea(edges: .bottom)

            if viewModel.isLoading {
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
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
