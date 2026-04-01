//
//  ContentView.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//


import SwiftUI

var movielist    = ["food1", "food2", "food3", "food4", "food5"]
var catogarylist = ["Roti sabzi", "Fast food", "Dosa", "Veg plate", "paneer tikka"]
var restaurantlist = [" North indian", " Burger Hub", " South Indian", "Tau di chaat", "Non veg food"]
var restaurantimg  = ["rest1", "rest2", "rest4", "rest3", "rest4"]

struct Cardnames3: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var isliked: Bool
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 16) {
                    ScrollView {
                        topheaderview()
                        bottomview()
                        scrollview()
                    }
                }.padding(10)
            }
        }.toolbar(.hidden)
    }
}

struct topheaderview: View {
    @State private var search: String = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hi, Kaptan").font(.title3)
                Text("find the best food around you")
                    .font(Font.caption.bold())
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Image(systemName: "magnifyingglass").font(.title3)
        }
        .padding(.horizontal)

        TextField("\(Image(systemName: "magnifyingglass")) search for dishes and restaurants", text: $search)
            .frame(height: 15)
            .padding()
            .background(Color(.white).opacity(0.5))
            .cornerRadius(8)
    }
}

struct bottomview: View {
    // Read the shared store from the environment
    @EnvironmentObject var favoritesStore: FavoritesStore

    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10)
    ]

    var body: some View {
        LazyVGrid(columns: column10, spacing: 20) {
            ForEach(movielist.indices, id: \.self) { img in
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

                                    // ❤️ Heart button — saves to FavoritesStore
                                    Button {
                                        favoritesStore.toggle(itemName)
                                    } label: {
                                        Image(systemName: favoritesStore.isLiked(itemName) ? "heart.fill" : "heart")
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

struct scrollview: View {
    var body: some View {
        HStack {
            Text("Popular Restaurants").font(Font.title.bold())
            Spacer()
            NavigationLink { PopularRestaurant() } label: {
                Image(systemName: "chevron.right").foregroundStyle(Color.gray)
            }
        }

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(restaurantimg.indices, id: \.self) { img in
                    VStack(spacing: -10) {
                        ZStack {
                            Image(restaurantimg[img])
                                .resizable()
                                .frame(minHeight: 50)
                                .frame(maxHeight: 150)
                                .frame(width: 200)
                                .aspectRatio(1/1, contentMode: .fill)
                                .clipped()
                        }
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 80)
                                .foregroundStyle(Color.black)
                                .opacity(0.1)
                            VStack {
                                Text(restaurantlist[img])
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 15, weight: .bold))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                HStack {
                                    ForEach(0..<4) { _ in
                                        Image(systemName: "star.fill").foregroundColor(.yellow)
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                                Text("4.5M Reviews")
                                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                            }
                            .padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0))
                        }
                    }
                    .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
}

