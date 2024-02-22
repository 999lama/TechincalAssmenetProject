//
//  LoginViewModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 22/02/2024.
//

import Foundation
import Combine


protocol LoginViewModelBinding: ObservableObject {
    var isLoginSuccess: Bool { get set }
}

protocol LoginViewModelCommand: ObservableObject {
    func savePasswordToKeychain(with userName: String, and password: String) 
}


class LoginViewModel: LoginViewModelBinding, LoginViewModelCommand {
    
    @Published var isLoginSuccess: Bool = false
    
    func savePasswordToKeychain(with userName: String, and password: String) {
        let keychainItem = KeychainItem(account: userName, password: password)
        
        do {
            try keychainItem.savePassword()
            isLoginSuccess = true
            UseCredentials.shared.loginUser(username: userName)
        } catch {
            print(error)
        }
    }
}
