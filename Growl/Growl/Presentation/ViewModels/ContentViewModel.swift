//
//  ContentViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var loginStatus: UserLoginStatus = .guest
}
