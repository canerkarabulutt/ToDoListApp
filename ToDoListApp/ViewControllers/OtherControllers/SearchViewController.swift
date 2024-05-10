//
//  SearchViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 9.05.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class SearchViewController: UIViewController {
    //MARK: - Properties
    private var results: [TaskModel] = []
            
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }))
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.font = UIFont.boldSystemFont(ofSize: 18)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search task...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchController.definesPresentationContext = true
        return searchController
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setupSearchController()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
//MARK: - Helpers
extension SearchViewController {
    private func setupSearchController() {
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.textColor = UIColor.label
        searchController.searchBar.searchTextField.contentVerticalAlignment = .center
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    private func style() {
        backgroundGradientColor()
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return results.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellIdentifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        let model = results[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedResult = results[indexPath.row]
        let vc = ListDetailViewController()
        vc.task = selectedResult
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmpty {
            fetchSearchResults(for: query)
        } else {
            results.removeAll()
            collectionView.reloadData()
        }
    }
    private func fetchSearchResults(for searchText: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let lowercaseSearchText = searchText.lowercased()
        
        var allResults: [TaskModel] = []
        
        let group = DispatchGroup()
        
        group.enter()
        TaskService.fetchCurrentTask(uid: uid) { currentTasks in
            let currentFilteredTasks = currentTasks.filter { task in
                return task.header.lowercased().contains(lowercaseSearchText) || task.text.lowercased().contains(lowercaseSearchText)
            }
            allResults.append(contentsOf: currentFilteredTasks)
            group.leave()
        }
        group.enter()
        TaskService.fetchCompletedTasks(uid: uid) { completedTasks in
            let completedFilteredTasks = completedTasks.filter { task in
                return task.header.lowercased().contains(lowercaseSearchText) || task.text.lowercased().contains(lowercaseSearchText)
            }
            allResults.append(contentsOf: completedFilteredTasks)
            group.leave()
        }
        group.enter()
        TaskService.fetchOverdueTasks(uid: uid) { overdueTasks in
            let overdueFilteredTasks = overdueTasks.filter { task in
                return task.header.lowercased().contains(lowercaseSearchText) || task.text.lowercased().contains(lowercaseSearchText)
            }
            allResults.append(contentsOf: overdueFilteredTasks)
            group.leave()
        }
        group.enter()
        TaskService.fetchPastTask(uid: uid) { pastTasks in
            let pastFilteredTasks = pastTasks.filter { task in
                return task.header.lowercased().contains(lowercaseSearchText) || task.text.lowercased().contains(lowercaseSearchText)
            }
            allResults.append(contentsOf: pastFilteredTasks)
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.results = allResults
            self.collectionView.reloadData()
        }
    }
}
