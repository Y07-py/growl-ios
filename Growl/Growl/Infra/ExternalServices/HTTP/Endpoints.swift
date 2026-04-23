//
//  Endpoints.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/23.
//

import Foundation

public enum API {
    static let baseEndpoint = "https://unimpairable-preevolutional-normand.ngrok-free.de"
    
    enum Health {
        static let health = baseEndpoint + "/health"
    }
    
    enum Auth {
        static let signUp = baseEndpoint + "/api/v1/auth/sign_up"
        static let signIn = baseEndpoint + "/api/v1/auth/sign_in"
        static let loginStatus = baseEndpoint + "/api/v1/auth/login_status"
    }
}

typealias AuthEndpoint = API.Auth
typealias HealthEndpoint = API.Health
