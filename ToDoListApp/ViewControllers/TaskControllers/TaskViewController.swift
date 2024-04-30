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
    private let taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .black
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
            self.profileView.user = user
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
extension TaskViewController {
    private func style() {
        backgroundGradientColor()
        self.navigationController?.navigationBar.isHidden = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        addNewTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.cornerRadius = 20
        profileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        profileView.delegate = self
        
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = .clear
        taskTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellIdentifier)
    }
    private func layout() {
        view.addSubview(addNewTaskButton)
        view.addSubview(taskTableView)
        view.addSubview(nameLabel)
        view.addSubview(profileButton)
        view.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileButton.bottomAnchor.constraint(equalTo: taskTableView.topAnchor, constant: -16),
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor, constant: 30),
            view.trailingAnchor.constraint(equalTo: addNewTaskButton.trailingAnchor, constant: 10),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 60),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 60),
                        
            taskTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: taskTableView.bottomAnchor, constant: 14),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            profileView.topAnchor.constraint(equalTo: profileButton.topAnchor, constant: 48),
            profileView.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6)
            
        ])
        view.bringSubviewToFront(addNewTaskButton)
        view.bringSubviewToFront(profileView)
    }
    private func configure() {
        guard let user = self.user else { return }
        nameLabel.text = "Welcome \(user.name),"
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
        cell.task = tasks[indexPath.section]
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
}
//MARK: - TaskDetailViewControllerDelegate
extension TaskViewController: TaskDetailViewControllerDelegate {
    func didDeleteTask() {
        fetchTasks()
    }
}
//MARK: - ProfileViewDelegate
extension TaskViewController: ProfileViewDelegate {
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

