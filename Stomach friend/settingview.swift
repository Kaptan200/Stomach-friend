//
//  settingview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    NavigationLink{
                        profilepageView()
                    }label: {
                        Image(systemName: "chevron.left")
                            .bold()
                    }.foregroundStyle(.primary)
                    Spacer()
                    Text("Settings")
                        .font(.largeTitle)
                    Spacer()
                }.padding()
                   
                    
                List {
                    Section("Account") {
                        Text("Edit profile")
                        Text("Your orders")
                        Text("History")
                      
                    }
                    
                    Section("Other") {
                        Text("Privacy policy")
                        Text("Help and support")
                        Text("About us")
                       
                    }
                }
            }.background(Color(.gray.opacity(0.1)))
            
        }.toolbar(.hidden)
    }
}

#Preview {
    SettingsView()
}

