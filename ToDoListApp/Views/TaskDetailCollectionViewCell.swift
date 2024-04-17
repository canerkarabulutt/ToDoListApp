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

    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
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
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.backgroundColor = .purple
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
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
        
        let horizontalCenter = contentView.frame.width / 2
        
        let calendarLabelSize = calendarLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        calendarLabel.frame = CGRect(x: horizontalCenter - calendarLabelSize.width / 2, y: taskLabel.bottom + 40, width: calendarLabelSize.width+4, height: calendarLabelSize.height + 12)
        
        let endDateLabelSize = endDateLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        endDateLabel.frame = CGRect(x: 6, y: calendarLabel.bottom + 20, width: contentView.width, height: endDateLabelSize.height*2)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        timerManager.stopTimer()
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
        let attributedString = NSMutableAttributedString(string: task.header.uppercased())
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        taskHeaderLabel.attributedText = attributedString
        taskLabel.text = task.text
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            calendarLabel.text = " \u{1F5D3} Added Date: \(dateString) \u{1F5D3}"
        } else {
            calendarLabel.text = "No selected date"
        }
        if let endDate = task.endDate {
            endDateLabel.text = "Remaining Time: Calculating..."
            timerManager.startTimer(for: endDate, updateHandler: { [weak self] timeString in
                self?.endDateLabel.text = "\u{23F0}Duration: \(timeString)"
            }, timeIsUpHandler: { [weak self] in
                self?.endDateLabel.text = "Time is Up!"
            })
        } else {
            endDateLabel.text = "No end date"
        }
    }
}
