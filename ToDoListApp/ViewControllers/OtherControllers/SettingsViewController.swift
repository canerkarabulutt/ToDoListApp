//
//  SettingsViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 5.05.2024.
//

import UIKit
import SafariServices
import StoreKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    private var viewModel = SettingsViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "ToDoListApp v1.0.1"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height*0.75)
        aboutLabel.frame = CGRect(x: 0, y: tableView.frame.maxY, width: view.bounds.width, height: view.bounds.height/8)
    }
}
//MARK: - Helpers
extension SettingsViewController {
    private func style() {
        title = "Settings"
        backgroundGradientColor()
        view.addSubview(tableView)
        view.addSubview(aboutLabel)
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.separatorColor = .black
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellIdentifier, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        let option = viewModel.settingsOptions[indexPath.row]
        cell.configure(with: option)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = viewModel.settingsOptions[indexPath.row]
        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option.type == .rateApp {
            SKStoreReviewController.requestReview()
        }
    }
}
