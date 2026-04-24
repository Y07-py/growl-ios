//
//  LoginView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var loginRouteViewModel: RouteViewModel<LoginRoute>
    
    @State private var authMethod: AuthMethodDTO = .email
    @State private var userName: String = ""
    @State private var userNameAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .center, spacing: 16) {
                    headerIconView
                    headerTitleView
                }
                .padding(.top, 60)
                
                VStack(alignment: .center, spacing: 32) {
                    authMethodView
                    
                    loginButtonView
                    
                    Text(.socialLoginTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.6))
                    
                    authSocialMethodView
                }
                .padding(.horizontal, 24)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    @ViewBuilder
    private var headerIconView: some View {
        Image("Growl-icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    @ViewBuilder
    private var headerTitleView: some View {
        Text(.loginTitle)
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundStyle(Color.mainColor)
    }
    
    @ViewBuilder
    private var authMethodView: some View {
        VStack(alignment: .center, spacing: 16) {
            Group {
                if authMethod == .email {
                    TextField(.authMethodPlaceholderEmail, text: $userName)
                } else {
                    TextField(.authMethodPlaceholderPhonenumber, text: $userName)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .baseShadow()
            
            Button(action: {
                userName.removeAll()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    authMethod = (authMethod == .email) ? .phoneNumber : .email
                }
            }) {
                Text(authMethod == .email ? .loginWthPhonenumber : .loginWithEmail)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.mainColor)
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var authSocialMethodView: some View {
        VStack(alignment: .center, spacing: 12) {
            socialLoginSection(assetName: "google-logo", title: .loginWithGoogle, width: 24, height: 24, fontSize: 16, fontWeight: .medium) {
                print("Googleでログイン")
            }
            socialLoginSection(assetName: "apple-logo", title: .loginWithApple, width: 24, height: 24, fontSize: 16, fontWeight: .medium) {
                print("Appleでログイン")
            }
        }
    }
    
    @ViewBuilder
    private func socialLoginSection(
        assetName: String,
        title: LocalizedStringResource,
        width: CGFloat,
        height: CGFloat,
        fontSize: CGFloat,
        fontWeight: Font.Weight,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: { action() }) {
            HStack(alignment: .center, spacing: 12) {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                Text(title)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .foregroundStyle(.black.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .baseShadow()
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var loginButtonView: some View {
        Button(action: {
            guard !userName.isEmpty else {
                withAnimation {
                    self.userNameAlert.toggle()
                }
                return
            }
            
        }) {
            HStack {
                Spacer()
                Text(.loginButtonTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(Color.mainColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .baseShadow()
    }
}
