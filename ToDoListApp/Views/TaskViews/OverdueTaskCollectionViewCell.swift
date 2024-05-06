//
//  OverdueTaskCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import UIKit
import FirebaseFirestore

class OverdueTaskCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "OverdueTaskCollectionViewCell"
    //MARK: - Properties
    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var checkMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.backgroundColor = .red
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .white
        return button
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(1)
        return view
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
        checkMarkButton.frame = CGRect(x: contentView.height/2-5, y: 5, width: contentView.height/4, height: contentView.height/4)
        calendarLabel.frame = CGRect(x: 4, y: checkMarkButton.bottom, width: contentView.height+10, height: (contentView.height*3)/4)
        taskHeaderLabel.frame = CGRect(x: calendarLabel.right+10, y: 2, width: contentView.width-calendarLabel.right-15, height: contentView.height/2)
        taskLabel.frame = CGRect(x: calendarLabel.right+10, y: taskHeaderLabel.bottom, width: contentView.width-calendarLabel.right-15, height: contentView.height/2)
        separatorView.frame = CGRect(x: calendarLabel.right+2, y: 0, width: 2, height: contentView.height)
    }
}
//MARK: - Helpers
extension OverdueTaskCollectionViewCell {
    private func style() {
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(checkMarkButton)
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.mainColor.cgColor
        checkMarkButton.layer.cornerRadius = contentView.height/8
        checkMarkButton.layer.masksToBounds = true
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
    }
}
