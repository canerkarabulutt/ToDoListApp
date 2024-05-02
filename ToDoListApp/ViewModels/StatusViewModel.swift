//
//  StatusViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import Foundation
import UIKit
import DGCharts

class StatusViewModel {
    private var taskStatistics: TaskStatistics
    
    init(taskStatistics: TaskStatistics) {
        self.taskStatistics = taskStatistics
    }
    
    var successRate: String {
        let totalTasks = Double(taskStatistics.ongoingTasks + taskStatistics.overdueTasks + taskStatistics.completedTasks + taskStatistics.deletedTasks)
        let completedPercentage = Double(taskStatistics.completedTasks) / totalTasks * 100.0
        return String(format: "%.1f", completedPercentage)
    }
    
    func generateChartData() -> PieChartDataSet {
        let chartData = [
            PieChartDataEntry(value: Double(taskStatistics.completedTasks), label: "Completed"),
            PieChartDataEntry(value: Double(taskStatistics.ongoingTasks), label: "Ongoing"),
            PieChartDataEntry(value: Double(taskStatistics.overdueTasks), label: "Overdue"),
            PieChartDataEntry(value: Double(taskStatistics.deletedTasks), label: "Deleted")
        ]
        
        let dataSet = PieChartDataSet(entries: chartData, label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        dataSet.valueFont = .systemFont(ofSize: 12, weight: .semibold)
        dataSet.entryLabelColor = .black
        dataSet.entryLabelFont = .systemFont(ofSize: 12, weight: .bold)
        
        return dataSet
    }
}
