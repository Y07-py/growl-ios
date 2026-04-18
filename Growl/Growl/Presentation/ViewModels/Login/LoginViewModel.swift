//
//  LoginViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI
import Combine

public enum LoginRoute: Equatable {
    case login
    case main
    case waiting
}

class LoginViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var mailAddress: String = ""
    @Published var phoneNumber: String = ""
}
