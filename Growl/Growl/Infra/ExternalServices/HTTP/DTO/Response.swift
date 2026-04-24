//
//  Model.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/23.
//

import Foundation
import SwiftUI

public struct LoginStatusResponse: Codable {
    public let loginStatus: LoginStatusDTO
    public let identity: UserIdentityDTO?
    
    enum CodingKeys: String, CodingKey {
        case loginStatus = "login_status"
        case identity
    }
}

public struct SessionResponse: Codable {
    public let session: AuthSessionDTO
}

public struct SignUpResponse: Codable {
    public let sessionId: String?
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case message
    }
}
