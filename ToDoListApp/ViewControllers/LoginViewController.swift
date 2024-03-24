//
//  LoginViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 22.03.2024.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - Properties
    
    private let loginImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.customMode()
        imageView.image = UIImage(named: "todo")
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
    private let emailTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Email...")
        return textField
    }()
    private let passwordTexField: UITextField = {
        let textField = TextFieldView(placeholder: "Password...")
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
    private lazy var containerGoRegister: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "New Around Here?"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "Create an account", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoRegister), for: .touchUpInside)
        
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
extension LoginViewController {
    @objc private func handleGoRegister(_ sender: UIButton) {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Helpers
extension LoginViewController {
    private func style() {
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, logInButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        loginImageView.translatesAutoresizingMaskIntoConstraints = false
        containerGoRegister.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(loginImageView)
        view.addSubview(stackView)
        view.addSubview(containerGoRegister)

        NSLayoutConstraint.activate([
            loginImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.75),
            loginImageView.heightAnchor.constraint(equalTo: loginImageView.widthAnchor),
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            
            stackView.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            containerGoRegister.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            containerGoRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            containerGoRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
}