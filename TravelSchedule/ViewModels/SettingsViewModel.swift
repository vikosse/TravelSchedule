//
//  SettingsViewModel.swift
//  TravelSchedule
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {

    var isDarkThemeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDarkThemeEnabled, forKey: AppStorageKey.isDarkThemeEnabled)
        }
    }

    init() {
        isDarkThemeEnabled = UserDefaults.standard.bool(forKey: AppStorageKey.isDarkThemeEnabled)
    }
}
