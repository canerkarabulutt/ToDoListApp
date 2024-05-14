//
//  LatesTaskViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 10.05.2024.
//

import Foundation
import FirebaseFirestore

struct LatesTaskViewModel {
    let taskHeader: String
    let taskLabel: String
    let calendarLabelText: String
    let endDateLabelText: String
    let isExpired: Bool
}

extension LatesTaskViewModel {
    init(task: TaskModel?) {
        guard let task = task else {
            self.taskHeader = ""
            self.taskLabel = ""
            self.calendarLabelText = ""
            self.endDateLabelText = ""
            self.isExpired = false
            return
        }
        
        self.taskHeader = task.header.uppercased()
        
        self.taskLabel = "- " + task.text
        
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            self.calendarLabelText = "\u{1F4C6}\(dateString)"
        } else {
            self.calendarLabelText = "No selected date"
        }
        if let endDate = task.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let endDateString = dateFormatter.string(from: endDate)
            self.endDateLabelText = "\u{23F3}\(endDateString)"
            
            self.isExpired = endDate < Date()
        } else {
            self.endDateLabelText = "No end date"
            self.isExpired = false
        }
    }
}
