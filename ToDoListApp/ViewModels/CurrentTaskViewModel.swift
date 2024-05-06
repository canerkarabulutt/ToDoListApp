//
//  CurrentTaskViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 6.05.2024.
//

import Foundation
import FirebaseFirestore

struct CurrentTaskViewModel {
    let taskHeader: String
    let calendarLabelText: String
    let endDateLabelText: String
    let isExpired: Bool
}

extension CurrentTaskViewModel {
    init(task: TaskModel?) {
        guard let task = task else {
            self.taskHeader = ""
            self.calendarLabelText = ""
            self.endDateLabelText = ""
            self.isExpired = false
            return
        }
        
        let uniqueCharacter = "\u{1F4CC}"
        self.taskHeader = uniqueCharacter + " " + (task.header.uppercased())
        
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
            self.endDateLabelText = "\u{2705}End Date: \(endDateString)"
            
            self.isExpired = endDate < Date()
        } else {
            self.endDateLabelText = "No end date"
            self.isExpired = false
        }
    }
}
