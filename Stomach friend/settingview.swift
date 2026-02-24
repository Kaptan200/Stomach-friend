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
                        Text("Edit profile")
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
                }
            }.background(Color(.gray.opacity(0.1)))
            
        }.toolbar(.hidden)
    }
}

#Preview {
    SettingsView()
}

