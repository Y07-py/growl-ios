//
//  LoginStatusDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/23.
//

import Foundation

public enum LoginStatusDTO: Codable {
    case guest
    case pending
    case active
    
    enum CodingKeys: String, CodingKey {
        case guest = "guest"
        case pending = "pending"
        case active = "active"
    }
}
