//
//  favorite.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI

struct Cardnames: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var isliked: Bool
}

struct favoriteview: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoritesStore: FavoritesStore

    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10)
    ]

    /// Only the items the user has hearted
    var likedItems: [Int] {
        movielist.indices.filter { favoritesStore.isLiked(movielist[$0]) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left").bold()
                        }
                        .foregroundStyle(Color.primary)
                        Spacer()
                        Text("Favorites")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "heart.fill").foregroundStyle(Color.red)
                    }

                    Spacer()

                    if likedItems.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Spacer()
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.gray.opacity(0.5))
                            Text("No favorites yet")
                                .font(.title2.bold())
                                .foregroundStyle(Color.gray)
                            Text("Tap ❤️ on any dish to save it here")
                                .font(.subheadline)
                                .foregroundStyle(Color.gray.opacity(0.8))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: column10, spacing: 20) {
                                ForEach(likedItems, id: \.self) { img in
                                    let itemName = movielist[img]

                                    VStack(spacing: -10) {
                                        ZStack {
                                            Image(itemName)
                                                .resizable()
                                                .frame(minHeight: 50)
                                                .frame(maxHeight: 250)
                                                .aspectRatio(1/1, contentMode: .fill)
                                                .clipped()

                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundStyle(Color.white)
                                                            .cornerRadius(9)

                                                        // ❤️ Un-heart from favorites
                                                        Button {
                                                            favoritesStore.toggle(itemName)
                                                        } label: {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundStyle(Color.red)
                                                        }
                                                    }
                                                }
                                                .padding(.trailing, 20)
                                                Spacer()
                                            }
                                            .padding(.top, 20)
                                        }

                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .frame(height: 60)
                                                .foregroundStyle(Color.white)
                                            VStack(alignment: .leading) {
                                                Text(catogarylist[img])
                                                    .foregroundStyle(Color.black)
                                                    .font(.system(size: 18, weight: .bold))

                                                HStack(spacing: 1) {
                                                    ForEach(0..<4) { _ in
                                                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.footnote)
                                                    }
                                                    Image(systemName: "star.fill").foregroundColor(.gray).font(.footnote)
                                                }
                                                Text("$120")
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                        }
                                    }
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemPink).opacity(0.10))
            }
        }.toolbar(.hidden)
    }
}

#Preview {
    favoriteview()
        .environmentObject(FavoritesStore())
}

