//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 1.05.2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    //MARK: - Properties
    private var user: UserModel? {
        didSet {
            configure()
        }
    }
    private let profileView = ProfileView()
    private let homeView = HomeView()
    private var isProfileViewActive: Bool = false
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        return button
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        return label
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchUser()
        homeView.navigationController = navigationController
        homeView.fetchLatestTask()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
//MARK: - Service
extension HomeViewController {
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchUser(uid: uid) { user in
            self.user = user
            self.profileView.user = user
        }
    }
}
//MARK: - Selector
extension HomeViewController {
    @objc private func didTapProfile(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.5) {
            if self.isProfileViewActive {
                self.profileView.frame.origin.x = self.view.frame.width
            } else {
                self.profileView.frame.origin.x = self.view.frame.width * 0.4
            }
        }
        self.isProfileViewActive.toggle()
    }
}
//MARK: - Helpers
extension HomeViewController {
    private func style() {
        backgroundGradientColor()
        self.navigationController?.navigationBar.isHidden = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.layer.cornerRadius = 20
        profileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        profileView.delegate = self
    }
    private func layout() {
        view.addSubview(nameLabel)
        view.addSubview(profileButton)
        view.addSubview(profileView)
        view.addSubview(homeView)
        
        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            homeView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 48),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            homeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/1.8),
            homeView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            profileView.topAnchor.constraint(equalTo: profileButton.topAnchor, constant: 48),
            profileView.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6)
            
        ])
        view.bringSubviewToFront(profileView)
    }
    private func configure() {
        guard let user = self.user else { return }
        nameLabel.text = "Welcome \(user.name),"
    }
}
//MARK: - ProfileViewDelegate
extension HomeViewController: ProfileViewDelegate {
    func didTapSettings() {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
