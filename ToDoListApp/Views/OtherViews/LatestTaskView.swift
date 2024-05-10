//
//  LatestTaskView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 10.05.2024.
//

import UIKit

class LatestTaskView: UIView {
    //MARK: - Properties
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "\u{1F4CC} Your Last Task \u{1F4CC}"
        label.textColor = .darkGray
        return label
    }()
    let clickInfo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Click to see the content of the last task..."
        label.textColor = .darkGray.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
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
    let latestTaskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
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
        infoLabel.frame = CGRect(x: 12, y: 2, width: width-8, height: height/8)
        latestTaskHeader.frame = CGRect(x: 4, y: infoLabel.bottom+10, width: width-4, height: height/8)
        latestTaskLabel.frame = CGRect(x: 12, y: latestTaskHeader.bottom, width: width-8, height: height/6)
        clickInfo.frame = CGRect(x: 4, y: latestTaskLabel.bottom+24, width: width-8, height: height/8)
        calendarLabel.frame = CGRect(x: 4, y: height-calendarLabel.height-8, width: width-4, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension LatestTaskView {
    private func style() {
        backgroundColor = .white.withAlphaComponent(0.7)
        layerStyle2()
    }
    private func layout() {
        addSubview(latestTaskHeader)
        addSubview(latestTaskLabel)
        addSubview(calendarLabel)
        addSubview(infoLabel)
        addSubview(clickInfo)
    }
}
