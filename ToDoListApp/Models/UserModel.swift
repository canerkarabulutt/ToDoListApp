//
//  UserModel.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import Foundation

struct UserModel {
    let email: String
    let name: String
    let profileImageUrl: String?
    let uid: String
    let username: String
    
    init(data: [String : Any]) {
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}

