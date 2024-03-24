//
//  TextFieldView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

class TextFieldView: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        textColor = .white
        borderStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
