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
        let vc2 = StatusViewController()
     //   let vc3 = PastTaskViewController()
        
     //   vc1.title = "Tasks"
        vc2.title = "Settings"
     //   vc3.title = "Past Tasks"
        
      //  vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
     //   vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
   //     let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Current", image: UIImage(systemName: "checklist"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "checkmark.circle.fill"), tag: 1)
    //    nav3.tabBarItem = UITabBarItem(title: "Past", image: UIImage(systemName: "clock.badge.checkmark"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
   //     nav3.navigationBar.prefersLargeTitles = true
        
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
