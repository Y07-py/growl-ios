//
//  LoginWaitingView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/17.
//

import SwiftUI

struct LoginWaitingView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var loginRouteViewModel: RouteViewModel<StartRoute>
    
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            VStack(alignment: .center) {
                Image("Growl-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                Text(.growl)
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(.black)
            }
        }
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                await self.loginViewModel.loginStatusCheck { status in
                    switch status {
                    case .active:
                        self.loginRouteViewModel.push(.main, animated: false)
                    case .guest, .pending:
                        self.loginRouteViewModel.push(.login, animated: false)
                    }
                }
            }
        }
    }
}
