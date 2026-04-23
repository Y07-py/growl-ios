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
}
