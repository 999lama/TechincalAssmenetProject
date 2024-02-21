//
//  UseCredentials.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import SwiftUI

class UseCredentials {
    static let shared = UseCredentials()
    private init() {}
    
    var isLoggedIn: Bool = false
    private(set) var username: String = ""

    func loginUser(username: String) {
        self.username = username
        self.isLoggedIn = true
    }

    func logoutUser() {
        self.username = ""
        self.isLoggedIn = false
    }
    
}

