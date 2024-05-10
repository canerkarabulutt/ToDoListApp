//
//  CurrentTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 6.05.2024.
//

import UIKit
import FirebaseAuth

class CurrentTaskViewController: UIViewController {
    //MARK: - Properties
    private var user: UserModel? {
        didSet {
            configure()
        }
    }
    private var cuurentTasks: [TaskModel] = []
    
    private let taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchUser()
        addSortButton()
    }
}
//MARK: - Selector
extension CurrentTaskViewController {
    @objc private func sortOptionsTapped() {
        let alertController = UIAlertController(title: "Sort Options", message: nil, preferredStyle: .actionSheet)
        
        let sortByStartDateAction = UIAlertAction(title: "Sort by Start Date", style: .default) { _ in
            self.sortTasksByStartDate()
        }
        alertController.addAction(sortByStartDateAction)

        let sortByHeaderAction = UIAlertAction(title: "Sort by A-Z", style: .default) { _ in
            self.sortTasksByHeader()
        }
        alertController.addAction(sortByHeaderAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        sortByStartDateAction.setValue(UIColor.purple, forKey: "titleTextColor")
        sortByHeaderAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")

        present(alertController, animated: true, completion: nil)
    }
}
//MARK: - Service
extension CurrentTaskViewController {
    private func fetchTasks() {
        guard let uid = self.user?.uid else { return }
        TaskService.fetchCurrentTask(uid: uid) { tasks in
            DispatchQueue.main.async {
                self.cuurentTasks = tasks
                self.taskTableView.reloadData()
            }
        }
    }
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchUser(uid: uid) { user in
            self.user = user
            self.fetchTasks()
        }
    }
}
//MARK: - Helpers
extension CurrentTaskViewController {
    private func style() {
        title = "Current Tasks"
        backgroundGradientColor()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
        
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = .clear
        taskTableView.register(CurrentTaskTableViewCell.self, forCellReuseIdentifier: CurrentTaskTableViewCell.cellIdentifier)
    }
    private func layout() {
        view.addSubview(taskTableView)
        
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: taskTableView.bottomAnchor, constant: 14),
            
        ])
    }
    private func configure() {
        fetchTasks()
    }
    private func addSortButton() {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(sortOptionsTapped))
        navigationItem.rightBarButtonItem = sortButton
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension CurrentTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cuurentTasks.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: CurrentTaskTableViewCell.cellIdentifier, for: indexPath) as? CurrentTaskTableViewCell else { return UITableViewCell() }
        let viewModel = CurrentTaskViewModel(task: cuurentTasks[indexPath.section])
        cell.configure(with: viewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/8
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTask = cuurentTasks[indexPath.section]
        let detailVC = ListDetailViewController()
        detailVC.task = selectedTask
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
//MARK: - Sort Optionws
extension CurrentTaskViewController {
    private func sortTasksByStartDate() {
        cuurentTasks.sort { $0.startDate < $1.startDate }
        taskTableView.reloadData()
    }
    private func sortTasksByHeader() {
        cuurentTasks.sort { $0.header.lowercased() < $1.header.lowercased() }
        taskTableView.reloadData()
    }
}
