//
//  ListDetailViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 8.05.2024.
//

import UIKit

class ListDetailViewController: UIViewController {
    //MARK: - Properties
    var task: TaskModel?
    var viewModel: TaskDetailViewModel?
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
        navigationController?.navigationBar.tintColor = .white
        guard let task = task else { return }
        viewModel = TaskDetailViewModel(task: task)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
}
//MARK: - Helpers
extension ListDetailViewController {
    private func style() {
        navigationController?.navigationBar.isHidden = false
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
extension ListDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskDetailCollectionViewCell.cellIdentifier, for: indexPath) as? TaskDetailCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(with: viewModel!)
        return cell
    }
}
