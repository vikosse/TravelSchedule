//
//  SettingsView.swift
//  TravelSchedule
//

import SwiftUI

struct SettingsView: View {

    @State private var viewModel = SettingsViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 0) {
            themeRow(isDarkThemeEnabled: $viewModel.isDarkThemeEnabled)
            agreementRow

            Spacer(minLength: 0)

            footer
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.ypWhite.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func themeRow(isDarkThemeEnabled: Binding<Bool>) -> some View {
        HStack {
            Text("Темная тема")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlack)

            Spacer(minLength: 0)

            Toggle("", isOn: isDarkThemeEnabled)
                .labelsHidden()
                .tint(Color.ypBlue)
        }
        .frame(height: 60)
    }

    private var agreementRow: some View {
        NavigationLink {
            UserAgreementView()
        } label: {
            HStack {
                Text("Пользовательское соглашение")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color.ypBlack)

                Spacer(minLength: 0)

                Image(.chevron)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.ypBlack)
            }
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var footer: some View {
        VStack(spacing: 16) {
            Text("Приложение использует API «Яндекс.Расписания»")
            Text("Версия 1.0 (beta)")
        }
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(Color.ypBlack)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.bottom, TabBarMetrics.contentHeight + 14)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
