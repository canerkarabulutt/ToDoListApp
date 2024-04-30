//
//  SettingsViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    private let profileView = ProfileView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
//MARK: - Helpers
extension SettingsViewController {
    private func style() {
        view.backgroundColor = .purple
        
    }
    private func layout() {

    }
}
