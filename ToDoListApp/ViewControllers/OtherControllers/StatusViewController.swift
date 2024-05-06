//
//  StatusViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import UIKit
import DGCharts
import FirebaseAuth

class StatusViewController: UIViewController {
    // MARK: - Properties
    let viewModel = StatusViewModel()
    let statusView = StatusView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientColor()
        setupView()
        fetchData()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusView.frame = view.bounds
    }
}
//MARK: - Service
extension StatusViewController {
    private func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        TaskService.fetchCompletedTasks(uid: uid) { [weak self] completedTasks in
            let completedTasksCount = completedTasks.count
            self?.fetchOverdueTasks(uid: uid, completedTasksCount: completedTasksCount)
        }
    }
    private func fetchOverdueTasks(uid: String, completedTasksCount: Int) {
        TaskService.fetchOverdueTasks(uid: uid) { [weak self] overdueTasks in
            let overdueTasksCount = overdueTasks.count
            self?.fetchPastTasks(uid: uid, completedTasksCount: completedTasksCount, overdueTasksCount: overdueTasksCount)
        }
    }
    private func fetchPastTasks(uid: String, completedTasksCount: Int, overdueTasksCount: Int) {
        TaskService.fetchPastTask(uid: uid) { [weak self] pastTasks in
            let pastTasksCount = pastTasks.count
            self?.fetchOngoingTasks(uid: uid, completedTasksCount: completedTasksCount, overdueTasksCount: overdueTasksCount, pastTasksCount: pastTasksCount)
        }
    }
    private func fetchOngoingTasks(uid: String, completedTasksCount: Int, overdueTasksCount: Int, pastTasksCount: Int) {
        TaskService.fetchTask(uid: uid) { [weak self] ongoingTasks in
            let ongoingTasksCount = ongoingTasks.count
            self?.viewModel.updateTaskStatistics(completedTasksCount: completedTasksCount, ongoingTasksCount: ongoingTasksCount, overdueTasksCount: overdueTasksCount, pastTasksCount: pastTasksCount)
            self?.updateUI()
        }
    }
}
//MARK: - UI Update
extension StatusViewController {
    private func updateUI() {
        if let statistics = viewModel.getTaskStatistics(), let chartDataSet = viewModel.getChartDataSet() {
            statusView.updateChartData(with: chartDataSet)
            updateSuccessRateLabel(statistics: statistics)
        }
    }
    private func updateSuccessRateLabel(statistics: TaskStatus) {
        let totalTasks = statistics.completedTasks + statistics.ongoingTasks + statistics.overdueTasks
        let completedPercentage = Double(statistics.completedTasks) / Double(totalTasks) * 100.0
        let formattedPercentage = String(format: "%.1f", completedPercentage)
        statusView.updateSuccessRateLabel(with: formattedPercentage)
    }
}
//MARK: - Helpers
extension StatusViewController {
    private func setupView() {
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
