//
//  StatusViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import Foundation
import UIKit
import DGCharts
import FirebaseAuth

class StatusViewModel {
    private var taskStatistics: TaskStatus?
    private var chartDataSet: PieChartDataSet?

    func getTaskStatistics() -> TaskStatus? {
        return taskStatistics
    }

    func getChartDataSet() -> PieChartDataSet? {
        return chartDataSet
    }

    func updateTaskStatistics(completedTasksCount: Int, ongoingTasksCount: Int, overdueTasksCount: Int, pastTasksCount: Int) {
        taskStatistics = TaskStatus(ongoingTasks: ongoingTasksCount, overdueTasks: overdueTasksCount, completedTasks: completedTasksCount, deletedTasks: 0)
        chartDataSet = generateChartData(completedTasksCount: completedTasksCount, overdueTasksCount: overdueTasksCount, pastTasksCount: pastTasksCount, ongoingTasksCount: ongoingTasksCount)
    }

    private func generateChartData(completedTasksCount: Int, overdueTasksCount: Int, pastTasksCount: Int, ongoingTasksCount: Int) -> PieChartDataSet {
        let chartData = [
            PieChartDataEntry(value: Double(completedTasksCount), label: "Completed"),
            PieChartDataEntry(value: Double(ongoingTasksCount), label: "Ongoing"),
            PieChartDataEntry(value: Double(overdueTasksCount), label: "Overdue"),
            PieChartDataEntry(value: Double(pastTasksCount), label: "Past")
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
