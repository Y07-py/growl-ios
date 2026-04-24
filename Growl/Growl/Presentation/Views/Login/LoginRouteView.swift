//
//  LoginRouteView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import Foundation
import SwiftUI

struct LoginRouteView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @StateObject private var routeViewModel: RouteViewModel<LoginRoute> = .init(route: .login)
    
    var body: some View {
        ZStack {
            RouteViewController(routeViewModel: routeViewModel) { route in
                switch route {
                case .login:
                    LoginView()
                case .otp:
                    LoginOTPView()
                }
            }
            .environmentObject(routeViewModel)
            .environmentObject(loginViewModel)
        }
        .ignoresSafeArea()
    }
}
