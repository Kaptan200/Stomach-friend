//
//  loginpage.swift
//  Stomach friend
//
//  Created by applelab03 on 2/11/26.
//
import SwiftUI
import Combine
struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    var body: some View {
   NavigationStack{
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
                .padding(EdgeInsets(top: -40, leading: 0, bottom: 0, trailing: 200))
               VStack(spacing: 20){
                 Text("Stomach friend")
                       .font(.largeTitle.italic())
                       .bold()
                       .foregroundStyle(Color.black)
                   HStack{
                       Text("sign in")
                           .font(.title3)
                           .bold()
                           .foregroundStyle(Color.black)
                           .padding(.bottom, 5)
                           .overlay(Rectangle().frame(height: 2).foregroundColor(.orange), alignment: .bottom)
                       Spacer()
                       Text("sign up")
                           .font(.title3)
                           .bold()
                           .foregroundStyle(Color.gray)
                   }.padding(.horizontal, 40)
                       .padding(20)
                
                   HStack{
                       Toggle("Remember me", isOn: $rememberMe)
                           .labelsHidden()
                           Text("I agree to the terms of service")
                           .font(Font.footnote)
                       Spacer()
                       
                       Text("Forgot password?")
                           .font(.footnote)
                   }.padding(.horizontal, 40)
                
                   .buttonStyle(.plain)
                   .padding(.horizontal, 40)
                   .padding(.top, 10)
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
               }.padding(50)
               .ignoresSafeArea(edges: .all)
           }
       }
        }
        
    }
}
struct signinview: View {
    @ObservedObject var auth: authviewmodel
    @State private var email = ""
    @State private var password = ""
 
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("E-mail address")
                .foregroundStyle(Color.black)
            
            TextField("Enter your email", text: $email)
               .frame(height: 15)
               .padding()
               .background(Color(.white).opacity(0.5))
                .cornerRadius(8)
            Text("password")
                .foregroundStyle(Color.black)
            
          SecureField("password", text: $password)
                 .frame(height: 15)
               .padding()
                .background(Color(.white).opacity(0.5))
                .cornerRadius(8)
            Button(action: { auth.login(email: email, password: password) }) {
                      Text("Log In")
                          .frame(maxWidth: .infinity)
                          .padding()
                          .background(Color.black)
                          .foregroundStyle(.white)
                          .clipShape(RoundedRectangle(cornerRadius: 10))
                  }
                  .disabled(auth.isLoading)
            
        }.padding(.horizontal, 40)
    }
}
final class authviewmodel: ObservableObject {
    @Published var isauthenticated: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errormessage: String?
    private var users:[String: String] = [:]
    
    func login(email: String, password: String){
        errormessage = nil
        isLoading=true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else {return}
            self.isLoading=false
            if email.isEmpty || password.isEmpty{
                self.errormessage = "PLEASE ENTER EMAIL AND PASSWORD."
            }
            guard let savedpassword = self.users[email] else {
                self.errormessage = "NO ACCOUNT FOUND FOR THIS EMAIL. PLEASE SIGN UP"
                return
            }
            guard password == savedpassword else {
                self.errormessage = "INCORRECT PASSWORD"
                return
            }
            self.errormessage = nil
            self.isauthenticated = true
        }
    }
    
    func signup(email: String, password: String, username: String){
        errormessage = nil
        isLoading=true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else {return}
            self.isLoading=false
            if email.isEmpty || password.isEmpty || username.isEmpty{
                self.errormessage = "PLEASE ENTER EMAIL AND PASSWORD."
                return
            }
            self.users[email] = password
            self.errormessage = nil
            self.isauthenticated = true
        }
    }
    func logout(){
        isauthenticated = false
    }
}
#Preview{
    LoginPage()
}
