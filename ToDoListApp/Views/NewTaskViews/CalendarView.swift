//
//  CalendarView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import UIKit

class CalendarView: UIDatePicker {
    //MARK: - Properties
    private let calendarBackgroundColor: UIColor = .white
    private let calendarTextColor: UIColor = .black
    private let selectedDateTextColor: UIColor = .black
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Date:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension CalendarView {
    private func setup() {
        self.datePickerMode = .dateAndTime
        self.backgroundColor = calendarBackgroundColor
        self.tintColor = .mainColor
        self.setValue(calendarTextColor, forKey: "textColor")
        self.locale = Locale(identifier: "en_US")
    }
    private func layout() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6)
        ])
    }
}
