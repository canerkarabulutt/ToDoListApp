//
//  StatusViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import UIKit
import DGCharts

class StatusViewController: UIViewController {
    private var statusView: StatusView!
    private var viewModel: StatusViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientColor()
        setupView()
        calculateStatistics()
    }
    
    private func setupView() {
        let viewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        statusView = StatusView(frame: viewFrame)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func calculateStatistics() {
        let taskStatistics = TaskStatistics(ongoingTasks: 20, overdueTasks: 10, completedTasks: 50, deletedTasks: 5)
        viewModel = StatusViewModel(taskStatistics: taskStatistics)
        
        let successRate = viewModel.successRate
        statusView.updateSuccessRateLabel(with: successRate)
        
        let chartData = viewModel.generateChartData()
        statusView.updateChartData(with: chartData)
    }
}

