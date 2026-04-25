//
//  Request.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/25.
//

import Foundation

public struct SignUpRequest: Codable {
    public let userName: String
    public let method: AuthMethodDTO
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case method
    }
}
