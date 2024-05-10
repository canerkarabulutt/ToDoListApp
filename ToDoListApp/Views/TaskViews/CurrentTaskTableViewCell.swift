//
//  CurrentTaskTableViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 6.05.2024.
//

import UIKit
import FirebaseFirestore

class CurrentTaskTableViewCell: UITableViewCell {
    static let cellIdentifier = "CurrentTaskTableViewCell"
    //MARK: - Properties
    var task: TaskModel? {
        didSet {
            if let task = task {
                let viewModel = CurrentTaskViewModel(task: task)
                configure(with: viewModel)
            }
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
        layer.borderWidth = 2
        layer.borderColor = UIColor.mainColor.cgColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
//MARK: - Helpers
extension CurrentTaskTableViewCell {
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
    public func configure(with viewModel: CurrentTaskViewModel) {
        taskHeaderLabel.text = viewModel.taskHeader
        calendarLabel.text = viewModel.calendarLabelText
        endDateLabel.text = viewModel.endDateLabelText
        
        if viewModel.isExpired {
            addExclamationMark()
        } else {
            removeExclamationMark()
        }
    }

    private func addExclamationMark() {
        let exclamationImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill"))
        exclamationImageView.tintColor = .red
        exclamationImageView.tag = 100
        addSubview(exclamationImageView)
        exclamationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exclamationImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            exclamationImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            exclamationImageView.widthAnchor.constraint(equalToConstant: 20),
            exclamationImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    private func removeExclamationMark() {
        if let exclamationView = viewWithTag(100) {
            exclamationView.removeFromSuperview()
        }
    }
    private func isTaskExpired(_ endDate: Date) -> Bool {
        return endDate < Date()
    }
}
