//
//  OverdueTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 2.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OverdueTaskViewController: UIViewController {
    //MARK: - Properties
    private var overdueTasks: [TaskModel] = []
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
        fetchOverdueTasks()
        setupLongPressGesture()
        addSortButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 4, y: 0, width: view.width - 8, height: view.height - 8)
    }
}
//MARK: - Selector
extension OverdueTaskViewController {
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
        let actionSheet = UIAlertController(title: "Remove", message: "Would you like to remove this task permanently?", preferredStyle: .actionSheet)

        let removeAction = UIAlertAction(title: "Remove Permanently", style: .destructive) { [weak self] _ in
            DispatchQueue.main.async {
                self?.deleteOverdueTask(at: indexPath.row)
                self?.collectionView.reloadData()
            }
        }
        actionSheet.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        removeAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        present(actionSheet, animated: true, completion: nil)
    }
    @objc private func sortOptionsTapped() {
        let alertController = UIAlertController(title: "Sort Options", message: nil, preferredStyle: .actionSheet)
        
        let sortByStartDateAction = UIAlertAction(title: "Sort by Start Date", style: .default) { _ in
            self.sortTasksByStartDate()
        }
        alertController.addAction(sortByStartDateAction)
        
        let sortByHeaderAction = UIAlertAction(title: "Sort by A-Z", style: .default) { _ in
            self.sortTasksByHeader()
        }
        alertController.addAction(sortByHeaderAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        sortByStartDateAction.setValue(UIColor.purple, forKey: "titleTextColor")
        sortByHeaderAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")

        present(alertController, animated: true, completion: nil)
    }
}
//MARK: - Service
extension OverdueTaskViewController {
    private func fetchOverdueTasks() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchOverdueTasks(uid: uid) { tasks in
            self.overdueTasks = tasks
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private func deleteOverdueTask(at index: Int) {
        let taskToDelete = overdueTasks[index]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("tasks").document(uid).collection("overdue_tasks").document(taskToDelete.taskId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed from Firestore!")
                self.overdueTasks.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}
//MARK: - Helpers
extension OverdueTaskViewController {
    private func style() {
        backgroundGradientColor()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(OverdueTaskCollectionViewCell.self, forCellWithReuseIdentifier: OverdueTaskCollectionViewCell.cellIdentifier)
    }
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    private func addSortButton() {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(sortOptionsTapped))
        navigationItem.rightBarButtonItem = sortButton
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension OverdueTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return overdueTasks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverdueTaskCollectionViewCell.cellIdentifier, for: indexPath) as? OverdueTaskCollectionViewCell else { return UICollectionViewCell()}
        let task = overdueTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedTask = overdueTasks[indexPath.row]
        let detailVC = ListDetailViewController()
        detailVC.task = selectedTask
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
//MARK: - Sort Optionws
extension OverdueTaskViewController {
    private func sortTasksByStartDate() {
        overdueTasks.sort { $0.startDate < $1.startDate }
        collectionView.reloadData()
    }
    private func sortTasksByHeader() {
        overdueTasks.sort { $0.header.lowercased() < $1.header.lowercased() }
        collectionView.reloadData()
    }
}
