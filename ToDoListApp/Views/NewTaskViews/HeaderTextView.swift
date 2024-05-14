//
//  HeaderTextView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import UIKit

class HeaderTextView: UITextView {
    //MARK: - Properties
    var placeHolder: String? {
        didSet {
            self.headerPlaceHolder.text = placeHolder
        }
    }
    private let headerPlaceHolder: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Selector
extension HeaderTextView {
    @objc private func handleTextView() {
        self.headerPlaceHolder.isHidden = !text.isEmpty
    }
}
//MARK: - Helpers
extension HeaderTextView {
    private func style() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextView), name: UITextView.textDidChangeNotification, object: nil)

        headerPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        font = .systemFont(ofSize: 16, weight: .regular)
        layer.borderColor = UIColor.mainColor.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 12
    }
    private func layout() {
        addSubview(headerPlaceHolder)
        
        NSLayoutConstraint.activate([
            headerPlaceHolder.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerPlaceHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
}
