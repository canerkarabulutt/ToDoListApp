//
//  ListDetailCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 8.05.2024.
//

import UIKit
import FirebaseFirestore

class ListDetailCollectionViewCell: UICollectionViewCell {
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        
        let taskLabelSize = taskLabel.sizeThatFits(CGSize(width: contentView.frame.width - 64, height: CGFloat.greatestFiniteMagnitude))
        taskLabel.frame = CGRect(x: 32, y: taskHeaderLabel.bottom + 20, width: taskLabelSize.width, height: taskLabelSize.height)
        
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
extension ListDetailCollectionViewCell {
    private func style() {
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
        contentView.addSubview(endDateLabel)
    }
    func configure(with viewModel: TaskDetailViewModel) {
        taskHeaderLabel.text = viewModel.taskHeader
        taskLabel.text = viewModel.taskText
        calendarLabel.text = viewModel.calendarLabelText
        endDateLabel.text = viewModel.endDateLabelText
        
        if let endDate = viewModel.endDate {
            endDateLabel.text = "Remaining Time: Calculating..."
            timerManager = TimerManager()
            timerManager.startTimer(for: endDate, updateHandler: { [weak self] timeString in
                self?.endDateLabel.text = "\u{23F3}Duration: \(timeString)"
            }, timeIsUpHandler: { [weak self] in
                self?.endDateLabel.text = "Time is Up!"
            })
        } else {
            endDateLabel.text = "No end date"
        }
    }
}
