//
//  LoginViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI
import Combine
import os
import libPhoneNumber

@MainActor
class LoginViewModel: ObservableObject {
    @Published var loginStatus: LoginStatusDTO = .pending
    @Published var identity: UserIdentityDTO? = nil
    @Published var dialCountries: [CountryDTO] = []
    
    private let checkLoginStatusUseCase = CheckLoginStatusInteractor.shared
    private let sessionUseCase = SessionInteractor.shared
    private let keyChain = KeychainClient.shared
    private let localRepository = LocalRepository.shared
    private let phoneUtil = NBPhoneNumberUtil.sharedInstance()
    private let logger: os.Logger = os.Logger(subsystem: "com.growl.app", category: "LoginViewModel")
    
    public init() {
        self.loadDialCountries()
    }
}

// MARK: - Public methods
extension LoginViewModel {
    /// Checks the current login status using the application layer.
    public func loginStatusCheck(completion: @escaping (LoginStatusDTO) -> Void) async {
        let (status, identity) = await checkLoginStatusUseCase.execute()
        
        self.loginStatus = status
        self.identity = identity
        completion(status)
    }
    
    public func loginRequest(userName: String, method: AuthMethodDTO, completion: @escaping (Bool) -> Void) async {
        do {
            if let identity = identity {
                // sign in process.
                completion(true)
            } else {
                let request = SignUpRequest(userName: userName, method: method)
                let response = try await sessionUseCase.signUp(request: request)
                if let sessionId = response.sessionId {
                    try keyChain.save(sessionId, for: "session_id")
                    completion(true)
                }
            }
        } catch {
            completion(false)
        }
    }
    
    public func sendOTP(otp: String) async {
        
    }
    
    public func validationPhoneNumber(userName: String, country: CountryDTO) -> String {
        do {
            let phoneNumber = country.dialCode + userName
            let parsedPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: country.countryCode)
            
            guard phoneUtil.isPossibleNumber(parsedPhoneNumber) else { return "" }
            
            let normPhoneNumber = try phoneUtil.format(parsedPhoneNumber, numberFormat: .E164)
            return normPhoneNumber
        } catch let error {
            logger.error("Failed to parsed phone number: \(error.localizedDescription)")
            return ""
        }
    }
}

// MARK: - Private helpers
extension LoginViewModel {
    private func loadDialCountries() {
        do {
            let countries: [Country] = try localRepository.fetchCountries()
            let countryDTOs: [CountryDTO] = countries.map({ CountryDTO(id: $0.id, dialCode: $0.dialCode, emoji: $0.emoji, countryCode: $0.code) })
            self.dialCountries = countryDTOs
        } catch let error {
            logger.error("Failed to load dial countries: \(error.localizedDescription)")
        }
    }
}
