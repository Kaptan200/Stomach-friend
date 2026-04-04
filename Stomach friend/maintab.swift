//
//  maintab.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//

import SwiftUI

struct maintab: View {
    // The store flows from Stomach_friendApp down through all tabs
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Explore")
                }
            ReelsView()
                .tabItem {
                    Image(systemName: "play.rectangle")
                    Text("Reels")
                }

            RecipesView()
                .tabItem {
                    Image(systemName: "crown.fill")
                    Text("SUBSCRIPTIONS")
                }

            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }

            profilepageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
        }
    }
}

#Preview {
    maintab()
        .environmentObject(FavoritesStore())
}
