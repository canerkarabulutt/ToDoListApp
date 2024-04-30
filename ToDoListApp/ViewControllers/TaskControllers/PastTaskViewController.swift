//
//  PastTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PastTaskViewController: UIViewController {
    //MARK: - Properties
    private var pastTasks: [TaskModel] = []
    private var isSelectModeEnabled = false
    private var selectedIndices: [IndexPath] = []
    
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return NSCollectionLayoutSection(group: group)
    }))
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        fetchPastTasks()
        setupLongPressGesture()
        selectButtonTapped()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 4, y: 0, width: view.width - 8, height: view.height - 8)
    }
}
//MARK: - Selector
extension PastTaskViewController {
    @objc private func selectButtonTapped() {
        
    }
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let taskToDelete = pastTasks[indexPath.row]
        let actionSheet = UIAlertController(title: "Remove", message: "Would you like to remove this task permanently?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            DispatchQueue.main.async {
                self?.deletePastTask(at: indexPath.row)
                self?.collectionView.reloadData()
            }
        }
        actionSheet.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        deleteAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        present(actionSheet, animated: true, completion: nil)
    }
}
//MARK: - Service
extension PastTaskViewController {
    private func fetchPastTasks() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        TaskService.fetchPastTask(uid: uid) { pastTasks in
            DispatchQueue.main.async {
                self.pastTasks = pastTasks
                self.collectionView.reloadData()
            }
        }
    }
    private func deletePastTask(at index: Int) {
        let taskToDelete = pastTasks[index]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("tasks").document(uid).collection("deleted_tasks").document(taskToDelete.taskId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed from Firestore!")
                self.pastTasks.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}
//MARK: - Helpers
extension PastTaskViewController {
    private func style() {
        backgroundGradientColor()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(PastTaskCollectionViewCell.self, forCellWithReuseIdentifier: PastTaskCollectionViewCell.cellIdentifier)
    }
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    private func selectButton() {
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        selectButton.tintColor = .white
        navigationItem.rightBarButtonItem = selectButton
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PastTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastTasks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PastTaskCollectionViewCell.cellIdentifier, for: indexPath) as? PastTaskCollectionViewCell else { return UICollectionViewCell()}
        let task = pastTasks[indexPath.row]
        cell.configure(with: task)
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedTask = pastTasks[indexPath.row]
        let detailVC = TaskDetailViewController()
        detailVC.task = selectedTask
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
