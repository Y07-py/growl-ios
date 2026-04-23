//
//  User.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation

public struct AuthenticationSession {
    public let identity: UserIdentity
    public let accessToken: String
    public let idToken: String
    public let refreshToken: String
    public let expiredAt: Date
}

public struct UserIdentity {
    public let subId: String
    public let email: String
    public let phoneNumber: String
    public let authenticationMethod: String
    public let role: String
}
