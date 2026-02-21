//
//  contentview5.swift
//  Stomach friend
//
//  Created by applelab03 on 2/20/26.
//
import SwiftUI
struct ContentView5: View {
    @StateObject private var auth = AuthViewModel()
    
    var body: some View {
        
                
        Group{
            if auth.isAuthenticated {
                 HomePageView()
             } else {
                AuthView(auth: auth)
            }
        }
               
            }
        }
 
struct HomePageView: View {

            
    var body: some View {
        NavigationStack{
            ZStack{
                    Color.black
                        .opacity(0.9)
                        .ignoresSafeArea()
                        VStack(spacing: 20){
                            VStack(spacing:5){
                                Text("Stomach Friend")
                                    .font(.system(size: 35, weight: .bold))
                                    .italic()
                                    .bold()
                                    .foregroundColor(.pink.opacity(0.5))
                                    .overlay(
                                      Text("Stomach Friend")
                                          .font(.system(size: 34, weight: .bold))
                                          .italic()
                                          .bold()
                                          .foregroundColor(.white.opacity(0.8))
                                          
                                    )
             
                            }.padding(30)
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                      LinearGradient(
                                          gradient: Gradient(colors: [.blue, .purple]),
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing
                                      )
                                    )
                                    .frame(height: 520)
                                VStack(spacing:20){
                                    Image("food1")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .offset(y: -50)
                                    VStack(spacing:10){
                                        Text("Welcome to our app")
                                            .font(.title)
                                            .foregroundColor(.white)
                                        Text("We are here to help you find the best restaurant in town")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
             
                                    Spacer()
                                    Button(action:{
                                        print("get started Tapped")
                                    }) {
                                        NavigationLink{
                                            ContentView()
                                        } label: {
                                            Text("Get Started")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .frame(maxWidth: 200)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(20)
                                        }
                                           
                                    }.padding(.horizontal, 40)
                                        .padding(.bottom, 25)
                                }
                            }
                            .padding(.horizontal, 20)
                            Spacer()
                        }
                      }
                }.toolbar(.hidden)
            }
            }

#Preview {
    ContentView5()
}

