//
//  SettingsModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import Foundation
import UIKit
import SafariServices
import StoreKit

// MARK: - Model
struct SettingsOption {
    enum OptionType {
        case notification
        case privacyPolicy
        case codeSource
        case feedback
        case about
        case rateApp
    }

    let type: OptionType
    let symbol: String

    var title: String {
        switch type {
        case .notification:
            return "\(symbol) Notifications"
        case .privacyPolicy:
            return "\(symbol) Privacy Policy"
        case .codeSource:
            return "\(symbol) Source of Code"
        case .feedback:
            return "\(symbol) Send Feedback"
        case .rateApp:
            return "\(symbol) Rate the App"
        case .about:
            return "\(symbol) About"
        }
    }

    var targetURL: URL? {
        switch type {
        case .privacyPolicy:
            return URL(string: "https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement")
        case .codeSource:
            return URL(string: "https://github.com/canerkarabulutt/ToDoListApp")
        case .feedback:
            return URL(string: "https://www.linkedin.com/in/caner-karabulut-7513391b4/")
        default:
            return nil
        }
    }
}
