//
//  SettingsView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import UIKit

class SettingsView: UIView {
    //MARK: - Properties
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
//MARK: - Helpers
extension SettingsView {
    private func style() {

    }
}
