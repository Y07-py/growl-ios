//
//  AuthTokenDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation
import SwiftUI

public struct AuthSessionDTO: Codable {
    public let identity: UserIdentityDTO
    public let accessToken: String
    public let idToken: String
    public let refreshToken: String
    public let expiredAt: Date
    
    enum CodingKeys: String, CodingKey {
        case identity
        case accessToken = "access_token"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case expiredAt = "expired_at"
    }
}
