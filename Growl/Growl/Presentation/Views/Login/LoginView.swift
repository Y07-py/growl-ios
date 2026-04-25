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
    @State private var selectedCountry: CountryDTO?
    
    @FocusState private var userNameFocus: Bool
    
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
            .onAppear {
                if selectedCountry == nil {
                    if let japan = loginViewModel.dialCountries.first(where: { $0.id == "JP" }) {
                        selectedCountry = japan
                    } else {
                        selectedCountry = loginViewModel.dialCountries.first
                    }
                }
            }
            .alert("入力エラー", isPresented: $userNameAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                if authMethod == .email {
                    Text(.usernameAlertWithEmail)
                } else if authMethod == .phoneNumber {
                    Text(.usernameAlertWithPhonenumber)
                }
            }
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
                        .focused($userNameFocus)
                } else {
                    HStack(spacing: 12) {
                        Menu {
                            Picker("Country", selection: $selectedCountry) {
                                ForEach(loginViewModel.dialCountries) { country in
                                    Text("\(country.emoji) \(country.dialCode)").tag(Optional(country))
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(selectedCountry?.emoji ?? "🇯🇵")
                                Text(selectedCountry?.dialCode ?? "+81")
                                    .font(.system(size: 16))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.gray)
                            }
                            .foregroundStyle(.black)
                        }
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 24)
                        
                        TextField(.authMethodPlaceholderPhonenumber, text: $userName)
                            .focused($userNameFocus)
                            .keyboardType(.phonePad)
                    }
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
            if authMethod == .phoneNumber {
                guard let selectedCountry = selectedCountry else { return }
                userName = loginViewModel.validationPhoneNumber(userName: userName, country: selectedCountry)
                if userName.isEmpty {
                    withAnimation {
                        self.userNameAlert.toggle()
                    }
                    return
                }
            }
            
            self.userNameFocus.toggle()
            Task {
                await loginViewModel.loginRequest(userName: userName, method: authMethod) { isSuccess in
                    if isSuccess {
                        loginRouteViewModel.push(.otp, animated: true)
                    } else {
                        
                    }
                }
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
