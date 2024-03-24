//
//  MainTabBarViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = TaskViewController()
        let vc2 = SettingsViewController()
        
        vc1.title = "Tasks"
        vc2.title = "Settings"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        nav1.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: "checkmark.circle"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2], animated: false)
        tabBarConfiguration()

    }
    private func tabBarConfiguration() {

        self.tabBar.itemPositioning = .fill
        self.tabBar.backgroundColor = .secondarySystemBackground
        self.tabBar.tintColor = .darkGray
        self.tabBar.unselectedItemTintColor = .lightGray
    }
}
