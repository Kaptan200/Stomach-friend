//
//  maintab.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI
struct maintab: View {
    var body: some View {
        TabView{
            ContentView()
            .tabItem {
                 Image(systemName: "house")
                     .foregroundStyle(.red)
                 Text("Explore")
             }
            
                favoriteview()
                .tabItem {
                Image(systemName: "heart")
                 Text("favorites")
            }
           
                MapView()
                .tabItem {
                Image(systemName: "map")
                 Text("Map")
            }
          
                profilepageView()
                .tabItem {
                Image(systemName: "person.fill")
                 Text("profile")
            }
        }
    }
}
#Preview {
    maintab()
}
