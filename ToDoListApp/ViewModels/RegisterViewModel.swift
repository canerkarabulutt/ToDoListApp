//
//  RegisterViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import UIKit

struct RegisterViewModel {
    var profileImageUrl: URL? 
    var emailText: String?
    var passwordText: String?
    var nameText: String?
    var usernameText: String?
    
    var status: Bool {
        return emailText?.isEmpty == false && passwordText?.isEmpty == false && nameText?.isEmpty == false && usernameText?.isEmpty == false
    }
}
