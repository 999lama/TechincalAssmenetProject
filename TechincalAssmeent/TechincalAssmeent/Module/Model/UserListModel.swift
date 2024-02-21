//
//  UserListModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 20/02/2024.
//

import Foundation

struct UserListModel: Decodable {
    let data: [ManagedUser]
}

struct UserModel: Codable, Identifiable, Hashable {
    let id: Int
    let name, email: String
    let gender: String
    let status: String
}
