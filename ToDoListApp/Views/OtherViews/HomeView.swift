//
//  HomeView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 9.05.2024.
//

import UIKit
import FirebaseAuth

class HomeView: UIView {
    //MARK: - Properties
    weak var navigationController: UINavigationController?
    
    private lazy var taskPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checklist"), for: .normal)
        button.setTitle("Browse", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleTaskPageButton), for: .touchUpInside)
        return button
    }()
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.badge.checkmark"), for: .normal)
        button.setTitle("Lists", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleTaskListButton), for: .touchUpInside)
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
    private lazy var settingsPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("Settings", for: .normal)
        button.homeButtonConfiguration()
        button.addTarget(self, action: #selector(handleSettingsPageButton), for: .touchUpInside)
        return button
    }()
    private let latestTaskView = LatestTaskView()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Selector
extension HomeView {
    @objc private func handleTaskPageButton(_ sender: UIButton) {
        let vc = TaskViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleTaskListButton(_ sender: UIButton) {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleStatusButton(_ sender: UIButton) {
        let vc = StatusViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleSettingsPageButton(_ sender: UIButton) {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Helpers
extension HomeView {
    private func style() {
        stackView = UIStackView(arrangedSubviews: [taskPageButton, listButton, statusButton, settingsPageButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        latestTaskView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(stackView)
        addSubview(latestTaskView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            
            latestTaskView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50),
            latestTaskView.centerYAnchor.constraint(equalTo: centerYAnchor),
            latestTaskView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            latestTaskView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/5)
            
        ])
    }
    public func fetchLatestTask() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchTask(uid: uid) { tasks in
            if let latestTask = tasks.first {
                let viewModel = LatesTaskViewModel(task: latestTask)
                self.latestTaskView.latestTaskHeader.text = viewModel.taskHeader
                self.latestTaskView.latestTaskLabel.text = viewModel.taskLabel
                self.latestTaskView.calendarLabel.text = viewModel.calendarLabelText
            }
        }
    }
}
