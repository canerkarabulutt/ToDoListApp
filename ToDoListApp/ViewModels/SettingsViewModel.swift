//
//  SettingsViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import Foundation

class SettingsViewModel {
    let settingsOptions: [SettingsOption] = [
        SettingsOption(type: .notification, symbol: "🔔"),
        SettingsOption(type: .privacyPolicy, symbol: "🔒"),
        SettingsOption(type: .codeSource, symbol: "🔍"),
        SettingsOption(type: .feedback, symbol: "✉️"),
        SettingsOption(type: .about, symbol: "ℹ️"),
        SettingsOption(type: .rateApp, symbol: "⭐️")
    ]
}
