//
//  UserDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation
import SwiftUI

public struct UserIdentityDTO: Codable {
    public let subId: String
    public let email: String
    public let phoneNumber: String
    public let authenticationMethod: String
    public let role: String
    
    enum CodingKeys: String, CodingKey {
        case subId = "sub_id"
        case email
        case phoneNumber = "phone_number"
        case authenticationMethod = "authentication_method"
        case role
    }
}
