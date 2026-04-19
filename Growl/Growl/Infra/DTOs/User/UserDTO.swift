//
//  UserDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation
import SwiftUI

public struct UserDTO: Codable {
    public let userId: String
    public let userName: String
    public let createdAt: Date
    public let updatedAt: Date
    public let mailAddress: String
    public let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mailAddress = "mail_address"
        case phoneNumber = "phone_number"
    }
}
