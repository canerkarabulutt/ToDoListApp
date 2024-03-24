//
//  TaskTableViewCell.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let cellIdentifier = "TaskTableViewCell"
    //MARK: - Properties
    private lazy var circleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.backgroundColor = .mainColor
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCircleButton), for: .touchUpInside)
        return button
    }()
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
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
    }
}
//MARK: - Selector
extension TaskTableViewCell {
    @objc private func handleCircleButton(_ sender: UIButton) {
        
    }
}
//MARK: - Helpers
extension TaskTableViewCell {
    private func setup() {
        circleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        addSubview(circleButton)
        addSubview(taskLabel)
        
        NSLayoutConstraint.activate([
            circleButton.heightAnchor.constraint(equalToConstant: 40),
            circleButton.widthAnchor.constraint(equalToConstant: 40),
            circleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            taskLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            taskLabel.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            taskLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}
