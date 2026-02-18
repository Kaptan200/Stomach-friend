//
//  loginpage.swift
//  Stomach friend
//
//  Created by applelab03 on 2/11/26.
//
import SwiftUI
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
                       .foregroundStyle(Color.orange)
                   HStack{
                       Text("sign in")
                           .font(.title3)
                           .bold()
                           .foregroundStyle(Color.orange)
                           .padding(.bottom, 5)
                           .overlay(Rectangle().frame(height: 2).foregroundColor(.orange), alignment: .bottom)
                       Spacer()
                       Text("sign up")
                           .font(.title3)
                           .bold()
                           .foregroundStyle(Color.gray)
                   }.padding(.horizontal, 40)
                       .padding(20)
                   VStack(alignment: .leading, spacing: 5){
                       Text("E-mail address")
                           .foregroundStyle(Color.gray)
                       
                       TextField("Enter your email", text: $email)
                          .frame(height: 15)
                          .padding()
                          .background(Color(.systemGray).opacity(0.5))
                           .cornerRadius(8)
                       Text("password")
                           .foregroundStyle(Color.gray)
                       
                     SecureField("password", text: $password)
                            .frame(height: 15)
                          .padding()
                           .background(Color(.systemGray).opacity(0.5))
                           .cornerRadius(8)
                       
                   }.padding(.horizontal, 40)
                   HStack{
                       Toggle("Remember me", isOn: $rememberMe)
                           .labelsHidden()
                           Text("I agree to the terms of service")
                           .font(Font.footnote)
                       Spacer()
                       
                       Text("Forgot password?")
                           .font(.footnote)
                   }.padding(.horizontal, 40)
                   Button(action: {
                       print("login tapped")
                   }) {
                       NavigationLink{
                           first_page()
                       }label: {
                           Text("login")
                               .font(.headline)
                               .bold()
                               .foregroundStyle(Color.white)
                               .frame(maxWidth: .infinity)
                               .padding()
                               .background(Color.orange)
                               .cornerRadius(25)
                       }
                   }
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
                       .foregroundStyle(Color.gray)
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
#Preview{
    LoginPage()
}
