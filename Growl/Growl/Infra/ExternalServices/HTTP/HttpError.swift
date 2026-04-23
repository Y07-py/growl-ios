//
//  HttpError.swift
//  Growl
//
//  Created by Antigravity on 2026/04/23.
//

import Foundation
import Alamofire

/// Custom error type for HTTP requests, encapsulating Alamofire errors.
public enum HttpError: Error {
    case invalidURL(url: String)
    case networkError(AFError)
    case noData
    case decodingError(Error)
    case unknown(Error?)
    
    /// Initializes a HttpError from a generic Error.
    init(error: Error) {
        if let afError = error as? AFError {
            self = .networkError(afError)
        } else if let httpError = error as? HttpError {
            self = httpError
        } else {
            self = .unknown(error)
        }
    }
}

extension HttpError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "Response returned no data."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error?.localizedDescription ?? "No description")"
        }
    }
}
