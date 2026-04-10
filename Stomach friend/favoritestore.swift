//
//  favoritestore.swift
//  Stomach friend
//
//  Created by applelab03 on 4/1/26.
//
import SwiftUI
import Combine

class FavoritesStore: ObservableObject {
   @Published var likedNames: Set<String> = []
    init() {}

    func isLiked(_ name: String) -> Bool {
        likedNames.contains(name)
    }

    func toggle(_ name: String) {
        if likedNames.contains(name) {
            likedNames.remove(name)
        } else {
            likedNames.insert(name)
        }
    }
}
