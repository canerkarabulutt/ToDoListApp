//
//  SearchCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 9.05.2024.
//

import UIKit
import FirebaseFirestore

class SearchCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SearchCollectionViewCell"
    //MARK: - Properties
    private let taskHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
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
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass.circle")
        imageView.tintColor = .systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        searchImageView.frame = CGRect(x: contentView.height/10-5, y: 10, width: contentView.height/4, height: contentView.height/4)
        calendarLabel.frame = CGRect(x: searchImageView.right+5, y: 10, width: contentView.width-searchImageView.right-15, height: contentView.height/4)
        taskHeaderLabel.frame = CGRect(x: contentView.height/10-5, y: searchImageView.bottom, width: contentView.width-10, height: contentView.height/3)
        taskLabel.frame = CGRect(x: contentView.height/10-5, y: taskHeaderLabel.bottom-10, width: contentView.width-15, height: contentView.height/4)
    }
}
//MARK: - Helpers
extension SearchCollectionViewCell {
    private func style() {
        contentView.addSubview(taskHeaderLabel)
        contentView.addSubview(taskLabel)
        contentView.addSubview(calendarLabel)
        contentView.addSubview(searchImageView)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.mainColor.cgColor
        searchImageView.layer.cornerRadius = contentView.height/8
        searchImageView.layer.masksToBounds = true
    }
    func configure(with task: TaskModel) {
        let headerColor = UIColor.purple
        let attributedHeader = NSMutableAttributedString(string: "Subject:  ", attributes: [NSAttributedString.Key.foregroundColor: headerColor])
        let attributedText = NSAttributedString(string: task.header.uppercased())
        attributedHeader.append(attributedText)
        taskHeaderLabel.attributedText = attributedHeader
        
        taskLabel.text = "- " + task.text
        
        let attributedString = NSMutableAttributedString(string: "Added Date: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        if let selectedDate = task.calendar["selectedDate"] as? Timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
            let dateString = dateFormatter.string(from: selectedDate.dateValue())
            let attributedDateString = NSAttributedString(string: dateString)
            attributedString.append(attributedDateString)
        } else {
            let noDateAttributedString = NSAttributedString(string: "No selected date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
            attributedString.append(noDateAttributedString)
        }
        calendarLabel.attributedText = attributedString
    }
}
