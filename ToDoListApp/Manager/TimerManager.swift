//
//  TimerManager.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 3.04.2024.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    private var timer: Timer?
    
    func startTimer(for endDate: Date, updateHandler: @escaping (String) -> Void, timeIsUpHandler: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentDate = Date()
            let timeDifference = endDate.timeIntervalSince(currentDate)
            
            if timeDifference <= 0 {
                timeIsUpHandler()
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            let timeString = self.stringFromTimeInterval(timeDifference, maxComponents: 3)
            updateHandler(timeString)
        }
    }
    private func stringFromTimeInterval(_ interval: TimeInterval, maxComponents: Int) -> String {
        let years = Int(interval) / 31536000
        let months = Int(interval) / 2592000 % 12
        let days = Int(interval) / 86400 % 30
        let hours = Int(interval) / 3600 % 24
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        
        var components: [String] = []
        
        if years > 0 && components.count < maxComponents {
            components.append("\(years) year")
        }
        if months > 0 && components.count < maxComponents {
            components.append("\(months) month")
        }
        if days > 0 && components.count < maxComponents {
            components.append("\(days) day")
        }
        if hours > 0 && components.count < maxComponents {
            components.append("\(hours) hour")
        }
        if minutes > 0 && components.count < maxComponents {
            components.append("\(minutes) minute")
        }
        if seconds > 0 && components.count < maxComponents {
            components.append("\(seconds) second")
        }
        return components.joined(separator: " ")
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
