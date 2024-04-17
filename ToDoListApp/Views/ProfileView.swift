//
//  ProfileView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 28.03.2024.
//

import UIKit

class ProfileView: UIView {
    var user: UserModel? {
        didSet {
            configure()
        }
    }
    //MARK: - Properties
    private let gradient = CAGradientLayer()

    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        return image
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.purple
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds

        let profileImageSize: CGFloat = bounds.height / 8
        profileImageView.frame = CGRect(x: (bounds.width - profileImageSize) / 2, y: 16, width: profileImageSize, height: profileImageSize)

        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 8, y: profileImageView.frame.maxY + 12, width: bounds.width - 16, height: profileImageSize / 2)

        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: 8, y: nameLabel.frame.maxY + 4, width: bounds.width - 16, height: profileImageSize / 2)
        let buttonWidth = bounds.width/2

        signOutButton.frame = CGRect(x: (bounds.width - buttonWidth) / 2, y: usernameLabel.bottom + 16, width: bounds.width/2, height: profileImageSize / 3)
    }

}
//MARK: - Selector
extension ProfileView {
    @objc private func handleSignOutButton(_ sender: UIButton) {
        
    }
}
//MARK: - Helpers
extension ProfileView {
    private func style() {
        layer.borderWidth = 3
        layer.borderColor = UIColor.mainColor.cgColor
        clipsToBounds = true
        gradient.locations = [0,1]
        gradient.colors = [UIColor.purple.cgColor, UIColor.black.cgColor]
        layer.addSublayer(gradient)
    }
    private func layout() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(signOutButton)
    }
    private func attributedTitle(headerTitle: String, title: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: "\(headerTitle): ", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.9), .font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        attributed.append(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .heavy)]))
        return attributed
    }
    private func configure() {
        guard let user = self.user else { return }
        self.usernameLabel.attributedText = attributedTitle(headerTitle: "Username", title: "\(user.username)")
        self.nameLabel.attributedText = attributedTitle(headerTitle: "Name", title: "\(user.name)")
        
    }
}
