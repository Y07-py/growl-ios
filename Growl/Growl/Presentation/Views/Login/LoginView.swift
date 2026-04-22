//
//  LoginView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(alignment: .center) {
                VStack(alignment: .center, spacing: .zero) {
                    headerIconView
                    headerTitleView
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    @ViewBuilder
    private var headerIconView: some View {
        HStack(alignment: .center) {
            Spacer()
            Image("Growl-icon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var headerTitleView: some View {
        Text("login-title")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(Color.mainColor)
    }
}
