//
//  TaskDetailViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 26.03.2024.
//

import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
    func didDeleteTask()
}

class TaskDetailViewController: UIViewController {
    //MARK: - Properties
    var task: TaskModel?
    var completedTasks: [TaskModel] = []
    weak var delegate: TaskDetailViewControllerDelegate?
        
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return NSCollectionLayoutSection(group: group)
    }))
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        navigationController?.navigationBar.tintColor = .black

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
}
//MARK: - Selector
extension TaskDetailViewController {
    @objc private func didTapCheck() {
        guard let task = task else { return }
        
        let alertController = UIAlertController(title: "Task Completed", message: "Are you sure you want to mark this task as completed?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let markCompletedAction = UIAlertAction(title: "Mark Completed", style: .default) { [weak self] _ in
            TaskService.markTaskAsCompleted(task: task) { error in
                if let error = error {
                    print("Error marking task as completed: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.delegate?.didDeleteTask()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        alertController.addAction(markCompletedAction)
        markCompletedAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        present(alertController, animated: true)
    }
    @objc private func didTapTrash() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.deleteItem()
        }
        alertController.addAction(removeAction)
        removeAction.setValue(UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        present(alertController, animated: true)
    }
    private func deleteItem() {
        guard let taskToDelete = task else { return }
        TaskService.deleteTask(task: taskToDelete) { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.delegate?.didDeleteTask()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
//MARK: - Helpers
extension TaskDetailViewController {
    private func style() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(didTapTrash)),
            UIBarButtonItem(image: UIImage(systemName: "checkmark.shield.fill"), style: .done, target: self, action: #selector(didTapCheck)),
        ]
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        backgroundGradientColor()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TaskDetailCollectionViewCell.self, forCellWithReuseIdentifier: TaskDetailCollectionViewCell.cellIdentifier)
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension TaskDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskDetailCollectionViewCell.cellIdentifier, for: indexPath) as? TaskDetailCollectionViewCell else { return UICollectionViewCell()}
        if let task = self.task {
            cell.configure(with: task)
        }
        return cell
    }
}
