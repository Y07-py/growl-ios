//
//  ContentView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel: ContentViewModel = .init()
    @StateObject private var startRouteViewModel: RouteViewModel<StartRoute> = .init(route: .waiting)
    @StateObject private var loginViewModel: LoginViewModel = .init()
    
    var body: some View {
        ZStack {
            RouteViewController(routeViewModel: startRouteViewModel, transitionDirection: .bottom) { route in
                switch route {
                case .login:
                    LoginRouteView()
                case .main:
                    MainView()
                case .waiting:
                    LoginWaitingView()
                }
            }
            .environmentObject(loginViewModel)
            .environmentObject(startRouteViewModel)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
