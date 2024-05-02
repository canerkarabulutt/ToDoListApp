//
//  SettingsModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 30.04.2024.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
