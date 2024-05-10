//
//  SettingsTableViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import UIKit
import FirebaseAuth

class SettingsTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let cellIdentifier = "SettingsTableViewCell"
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension SettingsTableViewCell {
    private func setup() {
        backgroundColor = .clear
    }
    func configure(with option: SettingsOption) {
        textLabel?.text = option.title
    }
}
