//
//  RegisterViewController.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 23.03.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: - Properties
    private var profileImage: UIImage?
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(selectProfilePhoto), for: .touchUpInside)
        return button
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
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layerStyle()
        button.isEnabled = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
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
    @objc private func selectProfilePhoto(_ sender:UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    @objc private func handleRegisterButton(_ sender: UIButton) {
        guard let emailText = emailTexField.text else { return }
        guard let passwordText = passwordTexField.text else { return }
        guard let usernameText = usernameTexField.text else { return }
        guard let nameText = nameTexField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        let user = AuthRegisterUserModel(emailText: emailText, passwordText: passwordText, usernameText: usernameText, nameText: nameText, profileImage: profileImage)
        AuthService.createUser(user: user) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
}
//MARK: - Helpers
extension RegisterViewController {
    private func style() {
        self.navigationController?.navigationBar.isHidden = true
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView,usernameContainerView,nameContainerView, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        goLoginContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(profileButton)
        view.addSubview(stackView)
        view.addSubview(goLoginContainerView)

        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor),
            profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            goLoginContainerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            goLoginContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            goLoginContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
}
//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImage = image
        profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        profileButton.layer.borderWidth = 3
        profileButton.layer.borderColor = UIColor.black.cgColor
        profileButton.clipsToBounds = true
        profileButton.contentMode = .scaleAspectFill
        self.dismiss(animated: true)
    }
}
