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
    private lazy var goToCurrentTaskPage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checklist"), for: .normal)
        button.setTitle("Browse", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleGoButton), for: .touchUpInside)
        return button
    }()
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.badge.checkmark"), for: .normal)
        button.setTitle("Lists", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleOtherTasksButton), for: .touchUpInside)
        return button
    }()
    private lazy var statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chart.bar.xaxis"), for: .normal)
        button.setTitle("Status", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleStatusButton), for: .touchUpInside)
        return button
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
//MARK: - Selector
extension HomeViewController {
    @objc private func handleGoButton(_ sender: UIButton) {
        let vc = TaskViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleOtherTasksButton(_ sender: UIButton) {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleStatusButton(_ sender: UIButton) {
        
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
        
        stackView = UIStackView(arrangedSubviews: [goToCurrentTaskPage, listButton, statusButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.cornerRadius = 20
        profileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        profileView.delegate = self
    }
    private func layout() {
        view.addSubview(nameLabel)
        view.addSubview(profileButton)
        view.addSubview(stackView)
        view.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            
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
