//
//  CarrierInfoView.swift
//  TravelSchedule
//

import SwiftUI

struct CarrierInfoView: View {

    // MARK: - Properties

    @StateObject private var viewModel: CarrierInfoViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    // MARK: - Initializer

    init(carrierCode: String) {
        _viewModel = StateObject(wrappedValue: CarrierInfoViewModel(carrierCode: carrierCode))
    }

    // MARK: - Body

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.ypWhite.ignoresSafeArea())
            .navigationTitle("Информация о перевозчике")
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
            ProgressView()
                .tint(Color.ypBlue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failure(let networkErrorKind):
            NetworkErrorView(kind: networkErrorKind) {
                Task { await viewModel.load() }
            }
        case .success(let carrier):
            carrierDetails(carrier)
        }
    }

    private func carrierDetails(_ carrier: Carrier) -> some View {
        let logoURL = logoURL(for: carrier)

        return VStack(alignment: .leading, spacing: 16) {
            if let logoURL {
                logoView(url: logoURL)
                    .padding(.top, 24)
            }

            Text(carrier.title ?? "")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.ypBlack)
                .padding(.top, logoURL == nil ? 24 : 0)

            VStack(alignment: .leading, spacing: 0) {
                if let email = carrier.email, !email.isEmpty {
                    contactRow(title: "E-mail", value: email, url: URL(string: "mailto:\(email)"))
                }

                if let phone = carrier.phone, !phone.isEmpty {
                    contactRow(title: "Телефон", value: phone, url: phoneURL(from: phone))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
    }

    private func logoView(url: URL) -> some View {
        HStack {
            Spacer(minLength: 0)

            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.ypLightGrey
            }
            .frame(height: 104)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }

    private func logoURL(for carrier: Carrier) -> URL? {
        guard let logo = carrier.logo, !logo.isEmpty else { return nil }
        return URL(string: logo)
    }

    private func contactRow(title: String, value: String, url: URL?) -> some View {
        Group {
            if let url {
                Button {
                    openURL(url)
                } label: {
                    contactRowLabel(title: title, value: value)
                }
                .buttonStyle(.plain)
            } else {
                contactRowLabel(title: title, value: value)
            }
        }
    }

    private func contactRowLabel(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlack)

            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.ypBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 60)
        .contentShape(Rectangle())
    }

    // MARK: - Private methods

    private func phoneURL(from phone: String) -> URL? {
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        return URL(string: "tel:\(digits)")
    }
}

#Preview {
    NavigationStack {
        CarrierInfoView(carrierCode: "26")
    }
}
