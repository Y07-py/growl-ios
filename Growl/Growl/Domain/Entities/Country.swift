//
//  Country.swift
//  Growl
//
//  Created by Antigravity on 2026/04/25.
//

import Foundation

public struct Country: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let code: String
    public let dialCode: String
    public let emoji: String
    public let unicode: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case dialCode = "dial_code"
        case emoji
        case unicode
    }
    
    public init(name: String, code: String, dialCode: String, emoji: String, unicode: String) {
        self.id = code
        self.name = name
        self.code = code
        self.dialCode = dialCode
        self.emoji = emoji
        self.unicode = unicode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.code = try container.decode(String.self, forKey: .code)
        self.dialCode = try container.decode(String.self, forKey: .dialCode)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.unicode = try container.decode(String.self, forKey: .unicode)
        self.id = self.code
    }
}
