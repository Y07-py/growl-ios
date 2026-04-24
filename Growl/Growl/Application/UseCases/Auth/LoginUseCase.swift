//
//  LoginUseCase.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import Foundation
import os
import Alamofire

public protocol SessionUseCase {
    func signIn(session: AuthSessionDTO) async -> Result<SessionResponse, HttpError>
    func signUp(request: SignUpRequest) async throws -> SignUpResponse
    func signOut() async -> Result<Void, HttpError>
}

public final class SessionInteractor {
    private let httpClient: HttpClient = HttpClient.shared
    private let logger: os.Logger = os.Logger(subsystem: "com.growl.app", category: "SessionInteractor")
}

extension SessionInteractor: SessionUseCase {
    public func signIn(session: AuthSessionDTO) async -> Result<SessionResponse, HttpError> {
        <#code#>
    }
    
    public func signUp(request: SignUpRequest) async throws -> SignUpResponse {
        let result: Result<SignUpResponse, HttpError> = await httpClient.post(url: AuthEndpoint.signUp, paramaters: request.asParameters())
        switch result {
        case .success(let response):
            logger.info("Receive sign up response")
            return response
        case .failure(let error):
            logger.error("Failed sign up request: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func signOut() async -> Result<Void, HttpError> {
        <#code#>
    }
}
