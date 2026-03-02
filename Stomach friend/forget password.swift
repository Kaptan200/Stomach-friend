//
//  forget password.swift
//  Stomach friend
//
//  Created by applelab03 on 3/1/26.
//
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    Spacer()
                    
                    // Title
                    VStack(spacing: 10) {
                        Text("Forgot Password?")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Enter your email address below and we'll send you a link to reset your password.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("example@email.com", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 24)
                    
                    // Reset Button
                    Button(action: {
                        // Handle reset password action
                    }) {
                        Text("Send Reset Link")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Back to Login
                    HStack {
                        Text("Remember your password?")
                            .foregroundColor(.gray)
                        
                        Button(action: { dismiss() }) {
                            Text("Login")
                         }
                         .foregroundStyle(Color.primary)
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 30)
                }
            }
        }.toolbar(.hidden)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

