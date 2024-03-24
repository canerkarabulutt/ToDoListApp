//
//  PastTaskViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

/*import UIKit

class PastTaskViewController: UIViewController {
    //MARK: - Properties
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: -30, leading: 0, bottom: -10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return NSCollectionLayoutSection(group: group)
    }))
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientColor()
        style()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
}
//MARK: - Helpers
extension PastTaskViewController {
    private func style() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TaskTableViewCell.self, forCellWithReuseIdentifier: TaskTableViewCell.cellIdentifier)
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PastTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as? TaskTableViewCell else { return UICollectionViewCell()}
        return cell
    }
}
*/
