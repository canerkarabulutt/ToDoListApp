//
//  TaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

import UIKit

class TaskViewController: UIViewController {
    //MARK: - Properties
    private let taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .white
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
//MARK: - Helpers
extension TaskViewController {
    private func style() {
        backgroundGradientColor()
        self.navigationController?.navigationBar.isHidden = true
        addNewTaskButton.translatesAutoresizingMaskIntoConstraints = false
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = .clear
        taskTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellIdentifier)
    }
    private func layout() {
        view.addSubview(addNewTaskButton)
        view.addSubview(taskTableView)
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor, constant: 30),
            view.trailingAnchor.constraint(equalTo: addNewTaskButton.trailingAnchor, constant: 10),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 60),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 60),
            
            taskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: taskTableView.trailingAnchor, constant: 8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: taskTableView.bottomAnchor, constant: 14),
        ])
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
