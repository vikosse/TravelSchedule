//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {

    @AppStorage(AppStorageKey.isDarkThemeEnabled) private var isDarkThemeEnabled = false

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
        }
    }
}
