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
    @EnvironmentObject private var startRouteViewModel: RouteViewModel<StartRoute>
    
    @StateObject private var loginRouteViewModel: RouteViewModel<LoginRoute> = .init(route: .login)
    
    var body: some View {
        ZStack {
            RouteViewController(routeViewModel: loginRouteViewModel, transitionDirection: .left) { route in
                switch route {
                case .login:
                    LoginView()
                case .otp:
                    LoginOTPView()
                }
            }
            .environmentObject(loginRouteViewModel)
            .environmentObject(startRouteViewModel)
            .environmentObject(loginViewModel)
        }
        .ignoresSafeArea()
    }
}
