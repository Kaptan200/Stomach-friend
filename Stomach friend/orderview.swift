//
//  orderview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct YourOrderView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Your Orders")
                    .font(.title)
                Text("Track and manage your current orders.")
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Orders")
            
        }
    }
}

#Preview {
   
        YourOrderView()
    
}

