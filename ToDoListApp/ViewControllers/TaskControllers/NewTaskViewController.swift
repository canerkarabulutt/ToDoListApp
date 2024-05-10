//
//  NewTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import UIKit

class NewTaskViewController: UIViewController {
    //MARK: - Properties
    private let newTaskLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "New Item", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 24)])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    private let calendarView: CalendarView = {
        let calendar = CalendarView()
        calendar.layer.cornerRadius = 12
        calendar.layer.borderWidth = 3
        calendar.layer.borderColor = UIColor.mainColor.cgColor
        calendar.clipsToBounds = true
        return calendar
    }()
    private let endDatePicker: TaskCompletedView = {
        let calendar = TaskCompletedView()
        calendar.layer.cornerRadius = 12
        calendar.layer.borderWidth = 3
        calendar.layer.borderColor = UIColor.mainColor.cgColor
        calendar.clipsToBounds = true
        return calendar
    }()
    private let taskHeaderView: InputTextView = {
        let inputTextView = InputTextView()
        inputTextView.placeHolder = "Enter Task Header..."
        return inputTextView
    }()
    private let taskTextView: InputTextView = {
        let inputTextView = InputTextView()
        inputTextView.placeHolder = "Enter Task..."
        return inputTextView
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layerStyle2()
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layerStyle()
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
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
        let endDate = endDatePicker.date
        TaskService.sendItem(taskText: taskText, headerText: headerText, calendar: calendarInfo, endDate: endDate) { error in
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
extension NewTaskViewController {
    private func style() {
        secondBackgroundGradientColor()
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.masksToBounds = true
        
        newTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTextView.translatesAutoresizingMaskIntoConstraints = false
        taskHeaderView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView(arrangedSubviews: [cancelButton, addButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(newTaskLabel)
        view.addSubview(taskTextView)
        view.addSubview(taskHeaderView)
        view.addSubview(calendarView)
        view.addSubview(stackView)
        view.addSubview(endDatePicker)
        
        NSLayoutConstraint.activate([
            newTaskLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            newTaskLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            newTaskLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            taskHeaderView.topAnchor.constraint(equalTo: newTaskLabel.bottomAnchor, constant: 12),
            taskHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskHeaderView.heightAnchor.constraint(equalToConstant: view.bounds.height / 16),
            
            taskTextView.topAnchor.constraint(equalTo: taskHeaderView.bottomAnchor, constant: 12),
            taskTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskTextView.heightAnchor.constraint(equalToConstant: view.bounds.height / 6),
            
            calendarView.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 16),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            
            endDatePicker.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            endDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endDatePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            
            stackView.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: view.bounds.height / 12),
        ])
    }
}
