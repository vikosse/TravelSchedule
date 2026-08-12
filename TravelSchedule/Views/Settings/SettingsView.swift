//
//  SettingsView.swift
//  TravelSchedule
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    var body: some View {
        List {
            Toggle("Тёмная тема", isOn: $isDarkThemeEnabled)
        }
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
