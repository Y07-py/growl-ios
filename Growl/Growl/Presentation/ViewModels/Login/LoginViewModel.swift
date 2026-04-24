//
//  LoginViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI
import Combine
import os

@MainActor
class LoginViewModel: ObservableObject {
    @Published var loginStatus: LoginStatusDTO = .pending
    @Published var identity: UserIdentityDTO? = nil
    
    private let checkLoginStatusUseCase = CheckLoginStatusInteractor()
    private let sessionUseCase = SessionInteractor()
    private let keyChain = KeychainClient.shared
    private let logger: os.Logger = os.Logger(subsystem: "com.growl.app", category: "LoginViewModel")
}

extension LoginViewModel {
    /// Checks the current login status using the application layer.
    public func loginStatusCheck(completion: @escaping (LoginStatusDTO) -> Void) async {
        let (status, identity) = await checkLoginStatusUseCase.execute()
        
        self.loginStatus = status
        self.identity = identity
        completion(status)
    }
    
    public func loginRequest(userName: String, method: AuthMethodDTO, completion: @escaping () -> Void) async {
        do {
            if let identity = identity {
                
            } else {
                let request = SignUpRequest(userName: userName, method: method)
                let response = try await sessionUseCase.signUp(request: request)
                if let sessionId = response.sessionId {
                    try keyChain.save(sessionId, for: "session_id")
                }
            }
        } catch let error {
            
        }
    }
    
    public func sendOTP(otp: String) async {
        
    }
}
