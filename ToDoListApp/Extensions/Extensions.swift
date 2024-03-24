//
//  Extensions.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

extension UIViewController {
    func backgroundGradientColor(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0,1]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
}

extension UIColor{
    static let mainColor = UIColor.systemPurple.withAlphaComponent(0.7)
}

extension UIView {
    var width : CGFloat {
        return frame.size.width
    }
    var height : CGFloat {
        return frame.size.height
    }
    var left : CGFloat {
        return frame.origin.x
    }
    var right : CGFloat {
        return left + width
    }
    var top : CGFloat {
        return frame.origin.y
    }
    var bottom : CGFloat {
        return top + height
    }
    func layerStyle() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 16
    }
}

extension UIImageView {
    func customMode() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    func imageLayout() {
        heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
    }
}
