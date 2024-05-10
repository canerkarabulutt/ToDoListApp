//
//  TaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

import UIKit
import FirebaseAuth

class TaskViewController: UIViewController {
    //MARK: - Properties
    private var user: UserModel? {
        didSet {
            configure()
        }
    }
    private var tasks: [TaskModel] = []
    
    private let taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(handleAddNewTaskButton), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchUser()
    }
}
//MARK: - Service
extension TaskViewController {
    private func fetchTasks() {
        guard let uid = self.user?.uid else { return }
        TaskService.fetchTask(uid: uid) { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
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
//MARK: - Selector
extension TaskViewController {
    @objc private func handleAddNewTaskButton(_ sender: UIButton) {
        let vc = NewTaskViewController()
        let screenSize = UIScreen.main.bounds.size
        let width = floor(screenSize.width * 3/4)
        let height = floor(screenSize.height * 3/4)
        vc.preferredContentSize = CGSize(width: width, height: height)
        let customDetent = UISheetPresentationController.Detent.custom(resolver: { (context) -> CGFloat? in
                return height
            })
        vc.sheetPresentationController?.detents = [customDetent]
        self.present(vc, animated: true)
        self.fetchTasks()
        self.taskTableView.reloadData()
    }
}
//MARK: - Helpers
extension TaskViewController {
    private func style() {
        title = "Tasks"
        backgroundGradientColor()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
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
                        
            taskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: taskTableView.bottomAnchor, constant: 14),
            
        ])
        view.bringSubviewToFront(addNewTaskButton)
    }
    private func configure() {
        fetchTasks()
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        let viewModel = TaskCellViewModel(task: tasks[indexPath.section])
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
        let selectedTask = tasks[indexPath.section]
        let detailVC = TaskDetailViewController()
        detailVC.task = selectedTask
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.section]
            TaskService.deleteTask(task: taskToDelete) { error in
                if let error = error {
                    print("Error deleting task: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.tasks.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Move to Overdue") { (action, view, completionHandler) in
            let taskToMove = self.tasks[indexPath.section]
            TaskService.moveTaskToOverdue(task: taskToMove) { error in
                if let error = error {
                    print("Error moving task to Overdue: \(error.localizedDescription)")
                } else {
                    self.tasks.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                }
            }
            completionHandler(true)
        }
        action.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
//MARK: - TaskDetailViewControllerDelegate
extension TaskViewController: TaskDetailViewControllerDelegate {
    func didDeleteTask() {
        fetchTasks()
    }
}
