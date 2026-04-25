//
//  Endpoints.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/23.
//

import Foundation

public enum API {
    static let baseEndpoint = "https://unimpairable-preevolutional-normand.ngrok-free.dev"
    
    enum Health {
        static let health = baseEndpoint + "/health"
    }
    
    enum Auth {
        static let signUp = baseEndpoint + "/api/v1/auth/signup"
        static let signIn = baseEndpoint + "/api/v1/auth/signin"
        static let signOut = baseEndpoint + "/api/v1/auth/signout"
        static let loginStatus = baseEndpoint + "/api/v1/auth/login_status"
    }
}

typealias AuthEndpoint = API.Auth
typealias HealthEndpoint = API.Health
