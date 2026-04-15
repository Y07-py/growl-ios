//
//  AuthToken.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation

public struct AuthToken {
    public let userId: String
    public let createdAt: Date
    public let expiredAt: Date
    public let token: String
}
