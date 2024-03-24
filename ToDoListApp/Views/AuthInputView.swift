//
//  AuthInputView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import Foundation
import UIKit

class AuthInputView: UIView {
    init(image: UIImage,textField: UITextField) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/12),
            
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

