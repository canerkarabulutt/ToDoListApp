//
//  MainTabBarViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        vc2.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "pencil.and.list.clipboard"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "doc.text.magnifyingglass"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2], animated: false)
        tabBarConfiguration()
        userStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func tabBarConfiguration() {
        self.tabBar.itemPositioning = .fill
        self.tabBar.backgroundColor = .secondarySystemBackground
        self.tabBar.tintColor = .darkGray
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    private func userStatus() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }else {
            print("There is a user.")
        }
    }
    private func signOut() {
        do {
            try Auth.auth().signOut()
            userStatus()
        }catch {
            
        }
    }
}
