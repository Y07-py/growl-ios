//
//  LoginViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var mailAddress: String = ""
    @Published var phoneNumber: String = ""
}
