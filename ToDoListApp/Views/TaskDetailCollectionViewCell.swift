//
//  RegisterCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit
import FirebaseFirestore

class TaskDetailCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "TaksDetailCollectionViewCell"
    //MARK: - Properties
    var task: TaskModel?
    
    private var timerManager = TimerManager.shared
    
    private let shapeLayer = CAShapeLayer()
    private var remainingTime: TimeInterval = 0
    private var totalTime: TimeInterval = 0

    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let taskHeaderLabelSize = taskHeaderLabel.sizeThatFits(CGSize(width: contentView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        taskHeaderLabel.frame = CGRect(x: (contentView.frame.width - taskHeaderLabelSize.width) / 2, y: 24, width: taskHeaderLabelSize.width, height: taskHeaderLabelSize.height)
        let taskLabelSize = taskLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        taskLabel.frame = CGRect(x: 20, y: taskHeaderLabel.bottom + 20, width: taskLabelSize.width, height: taskLabelSize.height)
        let calendarLabelSize = calendarLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        calendarLabel.frame = CGRect(x: contentView.frame.width - calendarLabelSize.width - 10, y: taskLabel.bottom + 30, width: calendarLabelSize.width, height: calendarLabelSize.height)
        let endDateLabelSize = endDateLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        endDateLabel.frame = CGRect(x: 6, y: calendarLabel.bottom + 40, width: contentView.width, height: endDateLabelSize.height*2)
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: contentView.bounds.midX, y: endDateLabel.frame.maxY + 50),
                                        radius: 20,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        contentView.layer.addSublayer(shapeLayer)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        timerManager.stopTimer()
        shapeLayer.removeFromSuperlayer()
    }
}
//MARK: - Helpers
extension TaskDetailCollectionViewCell {
    private func style() {
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
        contentView.addSubview(endDateLabel)
    }
    func configure(with task: TaskModel) {
        taskHeaderLabel.text = task.header.uppercased()
        taskLabel.text = task.text
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            calendarLabel.text = "Added Date: \(dateString)"
        } else {
            calendarLabel.text = "No selected date"
        }
        if let endDate = task.endDate {
            endDateLabel.text = "Remaining Time: Calculating..."
            startAnimating(with: endDate.timeIntervalSinceNow)
            timerManager.startTimer(for: endDate, updateHandler: { [weak self] timeString in
                self?.endDateLabel.text = "Duration: \(timeString)"
                self?.updateRemainingTime(endDate.timeIntervalSinceNow)
            }, timeIsUpHandler: { [weak self] in
                self?.endDateLabel.text = "Time is Up!"
                self?.stopAnimating()
            })
        } else {
            endDateLabel.text = "No end date"
        }
    }
    private func startAnimating(with totalTime: TimeInterval) {
        self.totalTime = totalTime
        remainingTime = totalTime
        updateShapeLayer()
    }
    
    private func updateShapeLayer() {
        let progress = CGFloat(remainingTime / totalTime)
        let endAngle = -CGFloat.pi / 2 + 2 * CGFloat.pi * progress
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: contentView.bounds.midX, y: endDateLabel.frame.maxY + 50),
                                        radius: 20,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: endAngle,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
    }
    
    private func updateRemainingTime(_ remainingTime: TimeInterval) {
        self.remainingTime = remainingTime
        updateShapeLayer()
    }
    
    private func stopAnimating() {
        shapeLayer.removeFromSuperlayer()
    }
}

