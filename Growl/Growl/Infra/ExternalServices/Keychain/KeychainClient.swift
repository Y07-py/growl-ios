//
//  KeychainClient.swift
//  Growl
//
//  Created by Antigravity on 2026/04/23.
//

import Foundation
import Security

/// A client to handle secure data storage using the iOS Keychain.
public final class KeychainClient {
    /// Singleton instance
    public static let shared = KeychainClient()
    
    private init() {}
    
    /// Saves a Codable object to the Keychain.
    /// - Parameters:
    ///   - value: The object to save.
    ///   - account: The account name (key) for the item.
    /// - Throws: KeychainError if the operation fails.
    public func save<T: Encodable>(_ value: T, for account: String) throws {
        let data = try JSONEncoder().encode(value)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, update it
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account
            ]
            
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributesToUpdate as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unhandledError(status: updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Retrieves a Codable object from the Keychain.
    /// - Parameters:
    ///   - type: The type of the object to retrieve.
    ///   - account: The account name (key) for the item.
    /// - Returns: The retrieved object.
    /// - Throws: KeychainError if the operation fails or item not found.
    public func get<T: Decodable>(_ type: T.Type, for account: String) throws -> T {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.unexpectedData
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Deletes an item from the Keychain.
    /// - Parameter account: The account name (key) for the item.
    /// - Throws: KeychainError if the operation fails.
    public func delete(for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
