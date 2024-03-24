//
//  RegisterViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: - Properties
    private let registerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.customMode()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .white
        return imageView
    }()
    private lazy var emailContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "envelope.fill")!, textField: emailTexField)
        containerView.layerStyle()
        containerView.backgroundColor = .purple
        return containerView
    }()
    private lazy var passwordContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "lock.fill")!, textField: passwordTexField)
        containerView.layerStyle()
        containerView.backgroundColor = .purple
        return containerView
    }()
    private lazy var usernameContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "person.fill")!, textField: usernameTexField)
        containerView.layerStyle()
        containerView.backgroundColor = .purple
        return containerView
    }()
    private lazy var nameContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "person")!, textField: nameTexField)
        containerView.layerStyle()
        containerView.backgroundColor = .purple
        return containerView
    }()
    private let emailTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Email...")
        return textField
    }()
    private let passwordTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Password...")
        return textField
    }()
    private let usernameTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Username...")
        return textField
    }()
    private let nameTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Name...")
        return textField
    }()
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private lazy var goLoginContainerView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "If you are a member,"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "Click here to back login page", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoLogin), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(label)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        return view
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientColor()
        style()
        layout()
    }
}
//MARK: - Selectors
extension RegisterViewController {
    @objc private func handleGoLogin() {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: - Helpers
extension RegisterViewController {
    private func style() {
        self.navigationController?.navigationBar.isHidden = true
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView,usernameContainerView,nameContainerView, logInButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        registerImageView.translatesAutoresizingMaskIntoConstraints = false
        goLoginContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(registerImageView)
        view.addSubview(stackView)
        view.addSubview(goLoginContainerView)

        NSLayoutConstraint.activate([
            registerImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4),
            registerImageView.heightAnchor.constraint(equalTo: registerImageView.widthAnchor),
            registerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: registerImageView.bottomAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            goLoginContainerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            goLoginContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            goLoginContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
}

