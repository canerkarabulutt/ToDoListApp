//
//  SettingsViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

class ListViewController: UIViewController {
    //MARK: - Properties
    private var sections = [Section]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureModels()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}
//MARK: - Helpers
extension ListViewController {
    private func style() {
        backgroundGradientColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    private func configureModels() {
        sections.append(Section(title: "Current Tasks", options: [Option(title: "View Your Current Tasks", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.viewCurrentTasks()
            }
        })]))
        sections.append(Section(title: "Completed Tasks", options: [Option(title: "View Your Completed Tasks", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.viewCompletedTasks()
            }
        })]))
        sections.append(Section(title: "Overdue Tasks", options: [Option(title: "View Your Overdue Tasks", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.viewOverdueTasks()
            }
        })]))
        sections.append(Section(title: "Past Tasks", options: [Option(title: "View Your Past Tasks", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.viewPastTasks()
            }
        })]))
    }
    private func viewCurrentTasks() {
        let vc = CurrentTaskViewController()
        vc.title = "Current Tasks"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func viewCompletedTasks() {
        let vc = CompletedTaskViewController()
        vc.title = "Completed Tasks"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func viewOverdueTasks() {
        let vc = OverdueTaskViewController()
        vc.title = "Overdue Tasks"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func viewPastTasks() {
        let vc = PastTaskViewController()
        vc.title = "Past Tasks"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - ProfileViewDelegate
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 15, y: -6, width: tableView.frame.width - 30, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = sections[section].title
        headerView.addSubview(label)
        return headerView
    }
}
