//
//  settingview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .bold()
                     }
                     .foregroundStyle(Color.primary)
                    Spacer()
                    Text("Settings")
                        .font(.largeTitle)
                    Spacer()
                }.padding()
                   
                    
                List {
                    Section("Account") {
                        NavigationLink{
                            EditProfileView()
                        }label: {
                            Text("Edit profile")
                        }
                        NavigationLink{
                            YourOrderView()
                        }label: {
                            Text("Your orders")
                        }
                        NavigationLink{
                            OrderHistoryView()
                        }label: {
                            Text("History")
                        }
                      
                    }
                    
                    Section("Other") {
                        NavigationLink{
                            PrivacyView()
                        }label: {
                            Text("Privacy policy")
                        }
                        NavigationLink{
                            HelpView()
                        }label: {
                            Text("Help and support")
                        }
                        NavigationLink{
                            AboutView()
                        }label: {
                            Text("About us")
                        }
                       
                    }
                } .scrollContentBackground(.hidden) // 🔥 remove white background
                    .background(Color.clear)
//                Button(action: {
//                    print("Delete Account")
//                }) {
//                    Text("Delete Account")
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                .padding(.top)
                
            }.background(LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
)
            
        }.toolbar(.hidden)
    }
}

#Preview {
    SettingsView()
}

