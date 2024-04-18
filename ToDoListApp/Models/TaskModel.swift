//
//  TaskModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import FirebaseFirestore

struct TaskModel {
    let header: String
    var taskId: String
    let text: String
    let timestamp: Timestamp
    let calendar : [String : Any]
    var endDate: Date?
    var isCompleted: Bool = false
    var startDate: Date
    var isSelected: Bool

    init(data: [String: Any]) {
        self.header = data["header"] as? String ?? ""
        self.taskId = data["taskID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.calendar = data["calendar"] as? [String: Any] ?? [:]
        if let endDateTimestamp = data["endDate"] as? Timestamp {
            self.endDate = endDateTimestamp.dateValue()
        } else {
            self.endDate = nil
        }
        self.isCompleted = data["completed"] as? Bool ?? false
        self.startDate = data["startDate"] as? Date ?? Date()
        self.isSelected = false
    }
    
    var dictionary: [String: Any] {
        return [
            "taskID": taskId,
            "header": header,
            "text": text,
            "timestamp": timestamp,
            "calendar": calendar,
            "endDate": endDate ?? 0,
            "completed": isCompleted,
            "startDate": startDate // Yeni eklenen başlangıç tarihi alanı
        ]
    }
}

