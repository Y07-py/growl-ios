//
//  KeychainError.swift
//  Growl
//
//  Created by Antigravity on 2026/04/23.
//

import Foundation

/// Custom error type for Keychain operations.
public enum KeychainError: Error {
    case duplicateItem
    case itemNotFound
    case unexpectedData
    case unhandledError(status: OSStatus)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .duplicateItem:
            return "The item already exists in the Keychain."
        case .itemNotFound:
            return "The item was not found in the Keychain."
        case .unexpectedData:
            return "The data retrieved from the Keychain was in an unexpected format."
        case .unhandledError(let status):
            return "An unhandled error occurred with status: \(status)."
        }
    }
}
