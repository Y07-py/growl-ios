//
//  AuthTokenDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation
import SwiftUI

public struct AuthTokenDTO: Codable {
    public let userId: String
    public let token: String
    public let createdAt: Date
    public let expiredAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case token
        case createdAt = "created_at"
        case expiredAt = "expired_at"
    }
    
    // Transform to domain model
    public func toDomain() -> AuthToken {
        .init(userId: userId, createdAt: createdAt, expiredAt: expiredAt, token: token)
    }
}
