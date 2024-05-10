//
//  PastTaskCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 28.03.2024.
//

import UIKit
import FirebaseFirestore

class PastTaskCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "PastTaskCollectionViewCell"
    //MARK: - Properties
    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray.withAlphaComponent(0.7)
        label.numberOfLines = 0
        return label
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        calendarLabel.frame = CGRect(x: 4, y: 20, width: contentView.height+10, height: (contentView.height*3)/4)
        taskHeaderLabel.frame = CGRect(x: calendarLabel.right+10, y: 2, width: contentView.width-calendarLabel.right-15, height: contentView.height/1.5)
        taskLabel.frame = CGRect(x: calendarLabel.right+10, y: taskHeaderLabel.bottom, width: contentView.width-calendarLabel.right-15, height: contentView.height/3)
        separatorView.frame = CGRect(x: calendarLabel.right+1, y: 0, width: 2, height: contentView.height)
    }
}
//MARK: - Helpers
extension PastTaskCollectionViewCell {
    private func style() {
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.mainColor.cgColor
        contentView.backgroundColor = .white
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
        contentView.addSubview(separatorView)
    }
    func configure(with task: TaskModel) {
        let headerColor = UIColor.darkGray
        let attributedHeader = NSMutableAttributedString(string: "Subject;\n\n 📝", attributes: [NSAttributedString.Key.foregroundColor: headerColor])
        let attributedText = NSAttributedString(string: task.header.uppercased())
        attributedHeader.append(attributedText)
        taskHeaderLabel.attributedText = attributedHeader
        
        taskLabel.text = "Click to see the content...🔍"
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
