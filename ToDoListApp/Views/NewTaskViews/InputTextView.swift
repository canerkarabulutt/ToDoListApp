//
//  InputTextView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import UIKit

class InputTextView: UITextView {
    //MARK: - Properties
    var placeHolder: String? {
        didSet {
            self.inputPlaceHolder.text = placeHolder
        }
    }
    private let inputPlaceHolder: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Selector
extension InputTextView {
    @objc private func handleTextView() {
        self.inputPlaceHolder.isHidden = !text.isEmpty
    }
}
//MARK: - Helpers
extension InputTextView {
    private func style() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextView), name: UITextView.textDidChangeNotification, object: nil)
        
        inputPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        font = .systemFont(ofSize: 18, weight: .regular)
        layer.borderColor = UIColor.mainColor.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 12
    }
    private func layout() {
        addSubview(inputPlaceHolder)
        
        NSLayoutConstraint.activate([
            inputPlaceHolder.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            inputPlaceHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
}
