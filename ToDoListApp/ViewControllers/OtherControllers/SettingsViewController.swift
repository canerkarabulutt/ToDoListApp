//
//  SettingsViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
//MARK: - Helpers
extension SettingsViewController {
    private func style() {
        title = "Settings"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        backgroundGradientColor()

    }
}
