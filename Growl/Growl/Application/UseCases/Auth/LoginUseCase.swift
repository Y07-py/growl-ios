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
    func signIn(session: AuthSessionDTO) async throws -> SignInResponse
    func signUp(request: SignUpRequest) async throws -> SignUpResponse
    func signOut(session: AuthSessionDTO) async throws -> Void
}

public final class SessionInteractor {
    private let httpClient: HttpClient = HttpClient.shared
    private let logger: os.Logger = os.Logger(subsystem: "com.growl.app", category: "SessionInteractor")
    
    static let shared: SessionInteractor = .init()
}

extension SessionInteractor: SessionUseCase {
    public func signIn(session: AuthSessionDTO) async throws -> SignInResponse {
        let result: Result<SignInResponse, HttpError> = await httpClient.post(url: AuthEndpoint.signIn, paramaters: session.asParamaters())
        switch result {
        case .success(let response):
            logger.info("Receive session response")
            return response
        case .failure(let error):
            logger.info("Failed to sign in to request: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func signUp(request: SignUpRequest) async throws -> SignUpResponse {
        let result: Result<SignUpResponse, HttpError> = await httpClient.post(url: AuthEndpoint.signUp, paramaters: request.asParamaters())
        switch result {
        case .success(let response):
            logger.info("Receive sign up response")
            return response
        case .failure(let error):
            logger.error("Failed to sign up request: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func signOut(session: AuthSessionDTO) async throws {
        let result: Result<Void, HttpError> = await httpClient.post(url: AuthEndpoint.signOut, paramaters: session.asParamaters())
        switch result {
        case .success:
            logger.info("Successfully to sign out.")
        case .failure(let error):
            logger.error("Failed to sign out request: \(error.localizedDescription)")
            throw error
        }
    }
}
