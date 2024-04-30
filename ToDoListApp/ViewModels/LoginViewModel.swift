//
//  LoginViewModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 30.04.2024.
//

import UIKit

struct LoginViewModel {
    var emailText: String?
    var passwordText: String?
    
    var status: Bool {
        return emailText?.isEmpty == false && passwordText?.isEmpty == false
    }
}
