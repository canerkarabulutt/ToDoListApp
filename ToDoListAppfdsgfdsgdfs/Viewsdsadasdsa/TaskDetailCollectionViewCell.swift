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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Item", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .mainColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layerStyle()
        button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        return button
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
        
        // Task header label
        let taskHeaderLabelSize = taskHeaderLabel.sizeThatFits(CGSize(width: contentView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        taskHeaderLabel.frame = CGRect(x: (contentView.frame.width - taskHeaderLabelSize.width) / 2, y: 20, width: taskHeaderLabelSize.width, height: taskHeaderLabelSize.height)
        let taskLabelSize = taskLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        taskLabel.frame = CGRect(x: 10, y: taskHeaderLabel.bottom + 20, width: taskLabelSize.width, height: taskLabelSize.height)
        let calendarLabelSize = calendarLabel.sizeThatFits(CGSize(width: contentView.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
        calendarLabel.frame = CGRect(x: contentView.frame.width - calendarLabelSize.width - 10, y: taskLabel.bottom + 20, width: calendarLabelSize.width, height: calendarLabelSize.height)
    }
}
//MARK: - Selector
extension NewTaskViewController {
    @objc private func handleAddButton() {
        guard let headerText = taskHeaderView.text else { return }
        guard let taskText = taskTextView.text else { return }
        let selectedDate = calendarView.date
        let calendarInfo: [String: Any] = [
            "selectedDate": selectedDate
        ]
        TaskService.sendItem(taskText: taskText, headerText: headerText, calendar: calendarInfo) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        self.dismiss(animated: true)
    }
    @objc private func handleCancelButton() {
        self.dismiss(animated: true)
    }
}
//MARK: - Helpers
extension TaskDetailCollectionViewCell {
    private func style() {
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
    }
    func configure(with task: TaskModel) {
        taskHeaderLabel.text = task.header
        taskLabel.text = task.text
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            calendarLabel.text = "Added Date: \(dateString)"
        } else {
            calendarLabel.text = "No selected date"
        }
    }
}

