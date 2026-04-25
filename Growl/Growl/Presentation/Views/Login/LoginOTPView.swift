//
//  LoginOTPView.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import SwiftUI

struct LoginOTPView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var loginRouteViewModel: RouteViewModel<LoginRoute>
    
    @State private var otpCode: String = ""
    @FocusState private var isFocused: Bool
    
    private let otpLength = 6
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 48) {
                // Header section
                VStack(spacing: 12) {
//                    Text(.otpTitle)
//                        .font(.system(size: 28, weight: .bold, design: .rounded))
//                        .foregroundStyle(Color.mainColor)
//                    
//                    Text(.otpSubtitle)
//                        .font(.system(size: 15))
//                        .foregroundStyle(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 40)
                }
                .padding(.top, 60)
                
                // OTP Input section
                VStack(spacing: 24) {
                    HStack(spacing: 12) {
                        ForEach(0..<otpLength, id: \.self) { index in
                            otpBox(at: index)
                        }
                    }
                    .background {
                        // Hidden TextField to capture all 6 digits and support auto-fill
                        TextField("", text: $otpCode)
                            .frame(width: 1, height: 1)
                            .opacity(0)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode) // Enable auto-fill from SMS
                            .focused($isFocused)
                            .onChange(of: otpCode) { _, newValue in
                                // Limit to otpLength
                                if newValue.count > otpLength {
                                    otpCode = String(newValue.prefix(otpLength))
                                }
                                
                                // Automatically trigger verification when all digits are entered
                                if otpCode.count == otpLength {
                                    Task {
                                        await loginViewModel.sendOTP(otp: otpCode)
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        isFocused = true
                    }
                    
                    Button(action: {
                        // Action to resend code
                        print("Resend code")
                    }) {
//                        Text(.otpResendButton)
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundStyle(Color.mainColor)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            // Delay focus slightly to ensure the keyboard appears smoothly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
    
    @ViewBuilder
    private func otpBox(at index: Int) -> some View {
        let char = getCharacter(at: index)
        let isCurrent = index == otpCode.count
        
        Text(char)
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .frame(width: 46, height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCurrent ? Color.mainColor : Color.gray.opacity(0.2), lineWidth: isCurrent ? 2 : 1)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .scaleEffect(isCurrent ? 1.05 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isCurrent)
    }
    
    private func getCharacter(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        let startIndex = otpCode.startIndex
        return String(otpCode[otpCode.index(startIndex, offsetBy: index)])
    }
}

#Preview {
    LoginOTPView()
        .environmentObject(LoginViewModel())
}
