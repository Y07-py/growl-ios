//
//  AuthMethodDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import Foundation

public enum AuthMethodDTO: Codable {
    case email(String)
    case phoneNumber(String)
    case google
    case apple
    
    enum CodingKeys: String, CodingKey {
        case email
        case phoneNumber = "phone_number"
        case google
        case apple
    }
}
