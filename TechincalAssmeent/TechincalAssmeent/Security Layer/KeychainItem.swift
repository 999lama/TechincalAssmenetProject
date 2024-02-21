//
//  KeychainItem.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import Foundation

/// A struct representing an item that can be stored securely in the Keychain, conforming to KeychainStorable protocol.
struct KeychainItem: KeychainStorable {
    
   
    let service: String
    let account: String
    let password: String
    
    /// Saves the Keychain item's password securely in the Keychain using KeychainManager.
    ///
    /// - Throws: An error if saving the password fails.
    func savePassword() throws {
        try KeychainManager.savePassword(for: self)
    }
    
    /// Loads the password associated with the Keychain item from the Keychain using KeychainManager.
    ///
    /// - Returns: The password if successful, otherwise throws an error.
    func loadPassword() throws -> String? {
        try KeychainManager.loadPassword(for: self)
    }
    
    /// Deletes the password associated with the Keychain item from the Keychain using KeychainManager.
    ///
    /// - Throws: An error if deleting the password fails.
    func deletePassword() throws {
        try KeychainManager.deletePassword(for: self)
    }
}
