//
//  LatestTaskView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 10.05.2024.
//

import UIKit

class LatestTaskView: UIView {
    //MARK: - Properties
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "\u{1F4CC} Your Last Task \u{1F4CC}"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 3
        label.layer.borderColor = UIColor.mainColor.cgColor
        return label
    }()
    let latestTaskHeader: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .purple
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        infoLabel.frame = CGRect(x: 0, y: 2, width: width, height: height/8)
        latestTaskHeader.frame = CGRect(x: 4, y: infoLabel.bottom+6, width: width-8, height: height/2)
        calendarLabel.frame = CGRect(x: 0, y: height-calendarLabel.height-height/6, width: width, height: height/6)
        endDateLabel.frame = CGRect(x: 0, y: height-calendarLabel.height, width: width, height: height/6)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension LatestTaskView {
    private func style() {
        backgroundColor = .white.withAlphaComponent(0.8)
        layerStyle2()
    }
    private func layout() {
        addSubview(latestTaskHeader)
        addSubview(endDateLabel)
        addSubview(calendarLabel)
        addSubview(infoLabel)
    }
}
