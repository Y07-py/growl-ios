//
//  AuthMethodDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import Foundation

public enum AuthMethodDTO: String, Codable {
    case email = "email"
    case phoneNumber = "phone_number"
    case google = "google"
    case apple = "apple"
}
