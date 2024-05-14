//
//  TaskDetailViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 7.05.2024.
//

import Foundation
import FirebaseFirestore

class TaskDetailViewModel {
    private let task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
    }
    
    var taskHeader: String {
        return task.header.uppercased()
    }
    
    var taskText: String {
        return task.text
    }
    
    var calendarLabelText: String {
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
            return "\u{1F5D3} Added Date: \(dateFormatter.string(from: selectedDate.dateValue())) \u{1F5D3}"
        } else {
            return "No selected date"
        }
    }
    
    var endDate: Date? {
        return task.endDate
    }
    
    var endDateLabelText: String {
        if let endDate = task.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return "\u{23F3}End Date: \(dateFormatter.string(from: endDate))"
        } else {
            return "No end date"
        }
    }
}
