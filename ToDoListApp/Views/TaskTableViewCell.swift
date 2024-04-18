//
//  TaskTableViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit
import FirebaseFirestore

class TaskTableViewCell: UITableViewCell {
    static let cellIdentifier = "TaskTableViewCell"
    //MARK: - Properties
    var task: TaskModel? {
        didSet {
            configure()
        }
    }
    private var countdownTimer: Timer?
    private func startTimer() {
        guard let endDate = task?.endDate else { return }
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let timeRemaining = endDate.timeIntervalSince(Date())
            guard timeRemaining > 0 else {
                self.endDateLabel.text = "Time is up!"
                timer.invalidate()
                return
            }
            self.timerLabel.text = self.formatTimeRemaining(timeRemaining)
        }
    }
    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    private func formatTimeRemaining(_ timeRemaining: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 3
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.allowsFractionalUnits = false
        guard let formattedString = formatter.string(from: timeRemaining) else {
            return "Expired"
        }
        return formattedString
    }
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(1)
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    //MARK: - Lifecyle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
}
//MARK: - Helpers
extension TaskTableViewCell {
    private func setup() {
        taskHeaderLabel.textAlignment = .center
        calendarLabel.textAlignment = .right
        taskHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(taskHeaderLabel)
        addSubview(calendarLabel)
        addSubview(separatorView)
        addSubview(endDateLabel)
        addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            
            calendarLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            calendarLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            taskHeaderLabel.topAnchor.constraint(equalTo: calendarLabel.bottomAnchor, constant: 4),
            taskHeaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -4),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: taskHeaderLabel.bottomAnchor, constant: 16),
            
            endDateLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            endDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            endDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
        ])
    }
    private func configure() {
        guard let task = self.task else { return }
        let uniqueCharacter = "\u{1F4CC}"
        taskHeaderLabel.text = uniqueCharacter + " " + (task.header.uppercased())
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            calendarLabel.text = "\u{1F4C6}\(dateString)"
        } else {
            calendarLabel.text = "No selected date"
        }
        if let endDate = task.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let endDateString = dateFormatter.string(from: endDate)
            endDateLabel.text = "\u{2705}End Date: \(endDateString)"
        } else {
            endDateLabel.text = "No end date"
        }
    }
}
