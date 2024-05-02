//
//  StatusView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import UIKit
import DGCharts

class StatusView: UIView {
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Task Statistics"
        return label
    }()
    private let successRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private var pieChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.holeColor = .purple
        chartView.rotationEnabled = true
        return chartView
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension StatusView {
    private func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        successRateLabel.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(titleLabel)
        addSubview(successRateLabel)
        addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        
            successRateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            successRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            successRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            pieChartView.topAnchor.constraint(equalTo: successRateLabel.bottomAnchor, constant: 20),
            pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pieChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pieChartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/5)
        ])
    }
    func updateSuccessRateLabel(with text: String) {
        successRateLabel.text = "Success Rate: \(text)%"
    }
    
    func updateChartData(with dataSet: PieChartDataSet) {
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
}
