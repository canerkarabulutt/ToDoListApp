//
//  CompletedTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 1.04.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CompletedTaskViewController: UIViewController {
    //MARK: - Properties
    private var completedTasks: [TaskModel] = []
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return NSCollectionLayoutSection(group: group)
    }))
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        fetchCompletedTasks()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 4, y: 0, width: view.width - 8, height: view.height - 8)
    }
}
//MARK: - Service
extension CompletedTaskViewController {
    private func fetchCompletedTasks() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchCompletedTasks(uid: uid) { completedTasks in
            DispatchQueue.main.async {
                self.completedTasks = completedTasks
                self.collectionView.reloadData()
            }
        }
    }
}
//MARK: - Helpers
extension CompletedTaskViewController {
    private func style() {
        backgroundGradientColor()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CompletedTaskCollectionViewCell.self, forCellWithReuseIdentifier: CompletedTaskCollectionViewCell.cellIdentifier)
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CompletedTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return completedTasks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedTaskCollectionViewCell.cellIdentifier, for: indexPath) as? CompletedTaskCollectionViewCell else { return UICollectionViewCell()}
        let task = completedTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedTask = completedTasks[indexPath.row]
        let detailVC = TaskDetailViewController()
        detailVC.task = selectedTask
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

