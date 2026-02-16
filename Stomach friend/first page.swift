//
//  first page.swift
//  Stomach friend
//
//  Created by applelab03 on 2/12/26.
//
import SwiftUI
struct first_page: View {
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
    //                  Text("Restaurant App")
    //                      .font(.title)
    //                      .foregroundColor(.white)
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
    //                      HStack(spacing: 8){
    //                          Circle().fill(Color.blue)
    //                              .frame(width: 8, height: 8)
    //
    //                      }
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
    first_page()
}
