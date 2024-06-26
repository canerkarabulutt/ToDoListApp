//
//  ProfileView.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 28.03.2024.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol ProfileViewDelegate: AnyObject {
    func signOutUser()
}

class ProfileView: UIView {
    var user: UserModel? {
        didSet {
            configure()
        }
    }
    //MARK: - Properties
    private let gradient = CAGradientLayer()
    
    weak var delegate: ProfileViewDelegate?
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        return image
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let emailLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "ToDoListApp v1.0.1"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        profileImageView.frame = CGRect(x: (bounds.width - profileImageSize) / 2, y: 24, width: profileImageSize, height: profileImageSize)
        profileImageView.layer.cornerRadius = profileImageSize / 2
        profileImageView.clipsToBounds = true

        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 8, y: profileImageView.frame.maxY + 12, width: bounds.width - 16, height: profileImageSize / 2)

        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: 8, y: nameLabel.frame.maxY + 4, width: bounds.width - 16, height: profileImageSize / 2)
        
        emailLabel.sizeToFit()
        emailLabel.frame = CGRect(x: width/12, y: usernameLabel.frame.maxY + 4, width: bounds.width - 16, height: profileImageSize / 2)
        
        let buttonWidth = bounds.width/2
        signOutButton.frame = CGRect(x: (bounds.width - buttonWidth) / 2, y: emailLabel.bottom + 50, width: bounds.width/2, height: profileImageSize / 3)
        
        aboutLabel.sizeToFit()
        aboutLabel.frame = CGRect(x: width/16, y: (height*3)/4, width: bounds.width - 16, height: profileImageSize / 2)
    }
}
//MARK: - Selector
extension ProfileView {
    @objc private func handleSignOutButton(_ sender: UIButton) {
        delegate?.signOutUser()
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
        addSubview(emailLabel)
        addSubview(signOutButton)
        addSubview(aboutLabel)
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
        self.emailLabel.attributedText = attributedTitle(headerTitle: "Email", title: "\(user.email)")
        if let profileImageURL = user.profileImageUrl {
            self.profileImageView.sd_setImage(with: URL(string: profileImageURL), completed: nil)
        }
    }
}
