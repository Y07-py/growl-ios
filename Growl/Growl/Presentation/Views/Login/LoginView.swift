//
//  LoginView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State private var authMethod: AuthenticationMethod = .email
    @State private var userName: String = ""
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(alignment: .center) {
                VStack(alignment: .center, spacing: .zero) {
                    headerIconView
                    headerTitleView
                }
                .padding(.horizontal, 10)
                authMethodView
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
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
        Text(.loginTitle)
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(Color.mainColor)
            .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private var authMethodView: some View {
        VStack(alignment: .center) {
            if authMethod == .email {
                TextField(.authMethodPlaceholderEmail, text: $userName)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.8), lineWidth: 1)
                    }
            } else {
                TextField(.authMethodPlaceholderPhonenumber, text: $userName)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.8), lineWidth: 1)
                    }
            }
            
            Button(action: {
                userName.removeAll()
                withAnimation {
                    if authMethod == .email {
                        authMethod = .phoneNumber
                    } else {
                        authMethod = .email
                    }
                }
            }) {
                if authMethod == .email {
                    Text(.loginWthPhonenumber)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.blue)
                } else {
                    Text(.loginWithEmail)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.blue)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var authSocialMethodView: some View {
        VStack {
            
        }
        .padding(.horizontal, 10)
    }
}
