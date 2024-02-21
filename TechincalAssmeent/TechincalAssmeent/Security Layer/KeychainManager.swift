//
//  KeychainManager.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import Foundation
import Security


/// A protocol defining properties required to access the Keychain.
protocol KeychainAccessible {
    var service: String { get }
    var account: String { get }
}

/// A protocol extending KeychainAccessible to include a password property.
protocol KeychainStorable: KeychainAccessible {
    var password: String { get }
}

//MARK: - KeychainError
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unexpectedItemData
    case duplicateEntry
    case unknown(status: OSStatus)
}

/// A manager class responsible for saving, loading, and deleting passwords from the Keychain.
final class KeychainManager {
    
    /// Saves a password to the Keychain for a given item.
    ///
    /// - Parameters:
    ///   - item: An object conforming to KeychainStorable protocol containing service, account, and password.
    /// - Throws: A KeychainError if saving the password fails.
    static func savePassword(for item: KeychainStorable) throws {
        
        if let encodedPassword = item.password.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: item.service,
                kSecAttrAccount as String: item.account,
                kSecValueData as String: encodedPassword
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                debugPrint("Password saved successfully")
            } else if status == errSecDuplicateItem {
                debugPrint("ERROR: duplicateEntry")
                throw KeychainError.duplicateEntry
            } else {
                debugPrint("ERROR: unknown \(status)")
                throw KeychainError.unknown(status: status)
            }
            
        }
    }
    
    /// Loads a password from the Keychain for a given item.
    ///
    /// - Parameters:
    ///   - item: An object conforming to KeychainAccessible protocol containing service and account.
    /// - Returns: The password if successful, otherwise throws an error.
    static func loadPassword(for item: KeychainAccessible) throws -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unknown(status: status) }
        
        if status == errSecSuccess {
            if let data = result as? Data,
               let password = String(data: data, encoding: .utf8) {
                debugPrint("Password loade successfully")
                return password
            }
        } else {
            debugPrint("ERROR: unexpected Password Data")
            throw KeychainError.unexpectedPasswordData
        }
        
        return nil
    }
    
    
    static func deletePassword(for item: KeychainAccessible) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            debugPrint("Password saved successfully")
        } else if status != noErr || status == errSecItemNotFound  {
            debugPrint("ERORR: unknown \(status)")
            throw KeychainError.unknown(status: status)
        }
    }
}

