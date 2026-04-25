//
//  CheckLoginStatusUseCase.swift
//  Growl
//
//  Created by Antigravity on 2026/04/23.
//

import Foundation
import os

/// A use case to check the current login status.
public protocol CheckLoginStatusUseCase {
    /// Executes the login status check.
    /// - Returns: A tuple containing the login status and optional user identity.
    func execute() async -> (LoginStatusDTO, UserIdentityDTO?)
}

/// Implementation of the CheckLoginStatusUseCase.

public final class CheckLoginStatusInteractor {
    private let httpClient: HttpClient = HttpClient.shared
    private let keychain: KeychainClient = KeychainClient.shared
    private let logger: os.Logger = os.Logger(subsystem: "com.growl.app", category: "CheckLoginStatusInteractor")
    
    static let shared: CheckLoginStatusInteractor = .init()
}

extension CheckLoginStatusInteractor: CheckLoginStatusUseCase {
    public func execute() async -> (LoginStatusDTO, UserIdentityDTO?) {
        // 1. Check if session exists in Keychain
        guard let session = self.getSessionFromKeyChain() else {
            return (.guest, nil)
        }
        
        // 2. Call API to verify status with the backend
        let statusResult: Result<LoginStatusResponse, HttpError> = await httpClient.post(url: AuthEndpoint.loginStatus,
                                                                                         paramaters: session.asParamaters())
        
        switch statusResult {
        case .success(let response):
            return (response.loginStatus, response.identity)
        case .failure(let error):
            self.logger.error("Failed to check login status via API: \(error.localizedDescription)")
            // If API fails, we treat it as guest or return last known status.
            // For now, following the original logic of returning guest on failure.
            return (.guest, nil)
        }
    }
    
    private func getSessionFromKeyChain() -> AuthSessionDTO? {
        do {
            return try self.keychain.get(AuthSessionDTO.self, for: "auth_session")
        } catch {
            // It's normal to not have a session if not logged in.
            return nil
        }
    }
}
