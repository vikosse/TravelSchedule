//
//  SettingsView.swift
//  TravelSchedule
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            themeRow
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

    // MARK: - Private views

    private var themeRow: some View {
        HStack {
            Text("Темная тема")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlack)

            Spacer(minLength: 0)

            Toggle("", isOn: $isDarkThemeEnabled)
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
        VStack(spacing: 4) {
            Text("Приложение использует API «Яндекс.Расписания»")
            Text("Версия 1.0 (beta)")
        }
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(Color.ypGray)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.bottom, TabBarMetrics.contentHeight + 24)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
