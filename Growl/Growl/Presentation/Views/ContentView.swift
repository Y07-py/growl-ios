//
//  ContentView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel: ContentViewModel = .init()
    @StateObject private var loginRouteViewModel: RouteViewModel<LoginRoute> = .init(route: .waiting)
    @StateObject private var loginViewModel: LoginViewModel = .init()
    
    var body: some View {
        ZStack {
            RouteViewController(routeViewModel: loginRouteViewModel, transitionDirection: .bottom) { route in
                switch route {
                case .login:
                    LoginView()
                case .main:
                    MainView()
                case .waiting:
                    LoginWaitingView()
                }
            }
            .environmentObject(loginViewModel)
            .environmentObject(loginRouteViewModel)
        }
    }
}

#Preview {
    ContentView()
}
