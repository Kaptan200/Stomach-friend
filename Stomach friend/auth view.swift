//
//  auth view.swift
//  Stomach friend
//
//  Created by applelab03 on 2/20/26.
//
import SwiftUI
import Combine
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var users: [String: String] = [:]
//    email -> password
    func login(email: String, password: String) {
        errorMessage = nil
        isLoading = true
        // Simulate async auth; replace with real backend later
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if email.isEmpty || password.isEmpty {
                self.errorMessage = "Please enter email and password."
                return
            }
            guard let savedPassword = self.users[email] else {
                self.errorMessage = "No account found for this email. Please sign up."
                return
            }
            guard password == savedPassword else {
                self.errorMessage = "Password is incorrect."
                return
            }
            self.errorMessage = nil
            self.isAuthenticated = true
        }
    }
    func signup(email: String, password: String, username: String) {
        errorMessage = nil
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if email.isEmpty || password.isEmpty || username.isEmpty {
                self.errorMessage = "Please fill all fields."
                return
            }
            // Add or update the user in-memory
            self.users[email] = password
            self.errorMessage = nil
            self.isAuthenticated = true
        }
    }
    func logout() {
        isAuthenticated = false
    }
}
     struct AuthView: View {
        @ObservedObject var auth: AuthViewModel
        @State private var selection: Int = 0
        var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.pink.opacity(0.3),  .purple.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("logo")
                     .resizable()
                     .scaledToFill()
                     .frame(width: 300, height: 280)
                     .clipShape(Circle())
                     .background(Color(.systemPink).opacity(0.10))
                     .padding(EdgeInsets(top: -100, leading: 0, bottom: 0, trailing: 200))
                    VStack(spacing: 20) {
                         Text("Stomach friend")
                              .font(.largeTitle.italic())
                              .bold()
                              .foregroundStyle(Color.black)
                        Picker("Auth", selection: $selection) {
                            Text("Log In").tag(0)
                            Text("Sign Up").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        if selection == 0 {
                            LoginView(auth: auth)
                        }
                        else{
                            Signup2View(auth: auth)
                        }
                        if let error = auth.errorMessage {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }
                        if auth.isLoading {
                            ProgressView().padding(.top, 8)
                        }
                        Spacer()
                    }
                    .padding(50)
                }
            }
        }
    }
struct LoginView: View {
    @ObservedObject var auth: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    var body: some View {
        VStack(spacing: 10) {
            TextField("Email", text: $email)
                .frame(height: 15)
                .padding()
                .background(Color(.white).opacity(0.5))
                 .cornerRadius(8)
            SecureField("Password", text: $password)
                .frame(height: 15)
                .padding()
                .background(Color(.white).opacity(0.5))
                 .cornerRadius(8)
            Button(action: { auth.login(email: email, password: password)
            }) {
                VStack(spacing: 30){
                    HStack{
                        Toggle("Remember me", isOn: $rememberMe)
                            .labelsHidden()
                            Text("I agree to the terms of service")
                            .font(Font.footnote)
                        Spacer()
                        
                        Text("Forgot password?")
                            .font(.footnote)
                    }.padding(-10)
                
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }
            }
            .disabled(auth.isLoading)
            .buttonStyle(.plain)
               .padding(.horizontal, 40)
               .padding(.top, 10)
            Spacer()
               HStack{
                   Rectangle()
                       .frame(height: 1)
                       .foregroundColor(.gray.opacity(0.5))
                   
                   Text("or")
                   
                   Rectangle()
                       .frame(height: 1)
                       .foregroundColor(.gray.opacity(0.5))
               }
               Text("Sign in using")
                   .foregroundStyle(Color.black)
               HStack(spacing:30){
                   Image(systemName: "applelogo")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 22, height: 32)
                       .foregroundStyle(.primary)
                   Image(systemName: "globe")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 22, height: 32)
                       .foregroundStyle(.primary)
                   Image(systemName: "f.square.fill")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 22, height: 32)
                       .foregroundStyle(.primary)
               }
        }
        .padding(.horizontal)
    }
}
struct Signup2View: View {
    @ObservedObject var auth: AuthViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack(spacing: 10) {
            TextField("Username", text: $username)
                .frame(height: 15)
                .padding()
                .background(Color(.white).opacity(0.5))
                 .cornerRadius(8)
            TextField("Email", text: $email)
                .frame(height: 15)
                .padding()
                .background(Color(.white).opacity(0.5))
                 .cornerRadius(8)
            SecureField("Password", text: $password)
                .frame(height: 15)
                .padding()
                .background(Color(.white).opacity(0.5))
                 .cornerRadius(8)
            Button(action: { auth.signup(email: email, password: password, username: username) })
            {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(auth.isLoading)
            Spacer()
            HStack{
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
                
                Text("or")
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
            }
            Text("Sign up using")
                .foregroundStyle(Color.black)
            HStack(spacing:30){
                Image(systemName: "applelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 32)
                    .foregroundStyle(.primary)
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 32)
                    .foregroundStyle(.primary)
                Image(systemName: "f.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 32)
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal)
    }
}
#Preview {
    AuthView(auth: AuthViewModel())
}
